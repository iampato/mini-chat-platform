import {
  Controller,
  Post,
  Body,
  HttpCode,
  BadRequestException,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiOkResponse,
  ApiOperation,
  ApiResponse,
  ApiTags,
} from '@nestjs/swagger';
import { AuthService } from '../service/auth.service';
import { SkipThrottle, Throttle } from '@nestjs/throttler';
import { ISuccess } from 'src/utils/types/success.interface';
import { LoginModel } from '../models/login.model';
import { LoginDto } from '../dtos/login.dto';
import { RefreshTokenDto } from '../dtos/refresh-token.dto';

@SkipThrottle()
@Controller('auth')
@ApiTags('Auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Throttle({ default: { limit: 2, ttl: 30000 } })
  @Post('login')
  @HttpCode(200)
  @ApiOperation({ summary: 'Login user' })
  @ApiResponse({
    status: 200,
    description: 'Login successful',
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid credentials or too many login attempts',
  })
  async login(@Body() loginDto: LoginDto): Promise<ISuccess<LoginModel>> {
    const response = await this.authService.login(
      loginDto.phone,
      loginDto.password,
    );
    if (!response) {
      throw new BadRequestException(
        'Invalid credentials or too many login attempts. Please try again later.',
      );
    }
    return {
      message: 'Login successful',
      data: response,
    };
  }

  @Post('refresh-token')
  @HttpCode(200)
  @ApiOkResponse({ description: 'Successfully refreshed token' })
  @ApiBadRequestResponse({ description: 'Invalid refresh token' })
  async refresh(@Body() body: RefreshTokenDto) {
    return this.authService.refreshToken(body.refreshToken);
  }
}
