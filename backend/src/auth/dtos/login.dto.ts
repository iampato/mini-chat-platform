import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';
import { IsValidPhoneNumber } from 'src/decorators/phone-validator.decorator';

export class LoginDto {
  @ApiProperty({ description: 'User phone number', example: '+1234567890' })
  @IsNotEmpty()
  @IsValidPhoneNumber({ message: 'phoneNumber must be a valid phone number' })
  phone: string;

  @ApiProperty({ description: 'User password', example: '123456789' })
  @IsNotEmpty()
  @IsString()
  password: string;
}
