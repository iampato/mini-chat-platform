import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { CreateUserDto } from '../dtos/create-user.dto';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async createDefaultUserIfNoneExists(): Promise<User | undefined> {
    try {
      const userCount = await this.userRepository.count();
      if (userCount === 0) {
        const defaultUser = new CreateUserDto();
        defaultUser.phone = '+254700000001';
        defaultUser.firstName = 'Default';
        defaultUser.lastName = 'User';
        defaultUser.password = '123456789';
        const results = await this.createUser(defaultUser);
        return results[0];
      }
    } catch (e) {
      throw e;
    }
  }

  async findOneById(id: string): Promise<User | undefined> {
    return await this.userRepository.findOne({
      where: { id },
      relations: ['roles', 'roles.permissions'],
    });
  }

  async findByPhone(phone: string): Promise<User | undefined> {
    return await this.userRepository.findOne({
      where: { phone },
    });
  }

  async createUser(user: CreateUserDto): Promise<User> {
    try {
      const newUser = new User();
      Object.assign(newUser, user);
      const createdUser = await this.userRepository.save(newUser);
      // remove password from the response
      delete createdUser.password;
      return createdUser;
    } catch (e) {
      // capture unique constraint error
      if (e.code === '23505') {
        throw new HttpException(
          'User already exists with that phone number',
          HttpStatus.BAD_REQUEST,
        );
      }
    }
  }

  async updateUserField(
    id: string,
    filters: Record<string, any>,
  ): Promise<User | undefined> {
    const user = await this.userRepository.findOne({
      where: { id },
    });
    if (!user) {
      throw new HttpException('User not found', HttpStatus.NOT_FOUND);
    }
    Object.assign(user, filters);
    delete user.password;
    const newUser = await this.userRepository.save(user);
    return newUser;
  }

  async deleteUser(id: string): Promise<boolean> {
    const user = await this.userRepository.findOne({ where: { id } });

    if (!user) {
      // If the user does not exist, return false to indicate the operation was not successful
      return false;
    }

    await this.userRepository.softDelete({
      id,
    });

    return true; // Return true to indicate the operation was successful
  }
}
