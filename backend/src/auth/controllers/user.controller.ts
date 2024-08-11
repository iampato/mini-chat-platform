import {
  Controller,
  Body,
  HttpCode,
  UseGuards,
  Patch,
  Delete,
} from '@nestjs/common';
import {
  ApiOkResponse,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AuthService } from '../service/auth.service';
import { SkipThrottle } from '@nestjs/throttler';
import { ISuccess } from 'src/utils/types/success.interface';
import { JwtAuthGuard } from 'src/guards/jwt-auth/jwt-auth.guard';
import { ChangePasswordDto } from '../dtos/change-password.dto';
import { UserModel } from '../models/user.model';
import { RequestContext } from 'nestjs-request-context';
import { UserService } from '../service/user.service';

@SkipThrottle()
@Controller('user')
@ApiTags('User')
export class UserController {
  constructor(
    private readonly authService: AuthService,
    private readonly userService: UserService,
  ) {}

  @Patch('change-password')
  @UseGuards(JwtAuthGuard)
  @ApiOperation({ summary: 'Change user password' })
  @ApiResponse({ status: 200, description: 'Password changed successfully' })
  async changePassword(
    @Body()
    changeDto: ChangePasswordDto,
  ): Promise<ISuccess<UserModel>> {
    const request = RequestContext.currentContext.req;
    const currentUser = request.user.sub;
    const user = await this.authService.changePassword(currentUser, changeDto);
    return {
      message: 'Password changed successfully',
      data: user,
    };
  }

  @Delete('delete')
  @UseGuards(JwtAuthGuard)
  @HttpCode(200)
  @ApiOperation({ summary: 'Delete user successfully' })
  @ApiOkResponse({ description: 'Successfully deleted user' })
  async deleteUser() {
    const request = RequestContext.currentContext.req;
    const currentUser = request.user.sub;
    return this.userService.deleteUser(currentUser);
  }
}
