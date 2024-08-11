import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { JwtService } from '@nestjs/jwt';
import { DateTime } from 'luxon';
import { UserService } from './user.service';
import { LoginModel } from '../models/login.model';
import { userEntityToModel, UserModel } from '../models/user.model';
import { ChangePasswordDto } from '../dtos/change-password.dto';

@Injectable()
export class AuthService {
  constructor(
    private readonly userService: UserService,
    private readonly jwtService: JwtService,
  ) {}

  async login(
    phone: string,
    password: string,
  ): Promise<LoginModel | undefined> {
    // console.log('phoneOrEmail: ', phoneOrEmail);
    const user = await this.userService.findByPhone(phone);
    if (!user) {
      throw new BadRequestException('Invalid credentials');
    }

    const passwordValid = await bcrypt.compare(password, user.password);

    if (!passwordValid) {
      throw new BadRequestException('Invalid credentials');
    }

    // update last login only if user has logged in before
    if (user.lastLogin) {
      await this.userService.updateUserField(user.id, {
        lastLogin: DateTime.utc().toJSDate(),
        updated: DateTime.utc().toJSDate(),
      });
    }

    const accessPayload = {
      username: user.firstName,
      sub: user.id,
      phone: user.phone,
    };
    const refreshTokenPayload = {
      sub: user.id,
    };

    const accessToken = this.jwtService.sign(accessPayload, {
      expiresIn: '30m',
    });
    const refreshToken = this.jwtService.sign(refreshTokenPayload, {
      expiresIn: '7d',
    });
    const userResponse: UserModel = userEntityToModel(user);

    return {
      accessToken,
      refreshToken,
      user: userResponse,
    };
  }

  async getUserByToken(token: string): Promise<UserModel | undefined> {
    try {
      const decoded = this.jwtService.verify(token);
      return decoded;
    } catch (e) {
      return undefined;
    }
  }

  async changePassword(
    id: string,
    dto: ChangePasswordDto,
  ): Promise<UserModel | undefined> {
    const { currentPassword, newPassword } = dto;
    const user = await this.userService.findOneById(id);

    if (!user) {
      // return a 404 error here
      throw new NotFoundException('User not found');
    }

    // check current password if it matches the one in the database
    const validPassword = await bcrypt.compare(currentPassword, user.password);
    // if the password is the same as the current one, throw an error
    if (!validPassword) {
      throw new BadRequestException(
        'Same password as the current one or the current password is incorrect',
      );
    }
    const updateUser = await this.userService.updateUserField(user.id, {
      password: newPassword,
      lastLogin: DateTime.utc().toJSDate(),
      updated: DateTime.utc().toJSDate(),
      lastPasswordChange: DateTime.utc().toJSDate(),
    });
    if (!updateUser) {
      throw new BadRequestException('Password change failed');
    }
    // update user with the new fields
    return userEntityToModel(updateUser);
  }

  async refreshToken(oldRefreshToken: string): Promise<any> {
    try {
      const decoded = this.jwtService.verify(oldRefreshToken);
      const user = await this.userService.findOneById(decoded.sub as string);
      if (!user) {
        throw new NotFoundException('User not found');
      }

      const accessPayload = {
        username: user.firstName,
        sub: user.id,
        phone: user.phone,
      };
      const refreshTokenPayload = {
        sub: user.id,
      };

      const accessToken = this.jwtService.sign(accessPayload, {
        expiresIn: '30m',
      });
      const refreshToken = this.jwtService.sign(refreshTokenPayload, {
        expiresIn: '7d',
      });

      return {
        accessToken,
        refreshToken,
      };
    } catch (e) {
      throw e;
    }
  }
}
