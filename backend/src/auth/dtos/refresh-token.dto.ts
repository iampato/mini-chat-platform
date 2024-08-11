import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class RefreshTokenDto {
  @ApiProperty({ description: 'User password', example: '123456789' })
  @IsNotEmpty()
  @IsString()
  refreshToken: string;
}
