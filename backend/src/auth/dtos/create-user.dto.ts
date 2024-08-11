import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';
import { IsValidPhoneNumber } from 'src/decorators/phone-validator.decorator';

export class CreateUserDto {
  @ApiProperty({ description: 'User phone number', example: '+1234567890' })
  @IsNotEmpty()
  @IsValidPhoneNumber({ message: 'phoneNumber must be a valid phone number' })
  phone: string;

  @ApiProperty({ description: 'User first name', example: 'John' })
  @IsNotEmpty()
  @IsString()
  firstName: string;

  @ApiProperty({ description: 'User last name', example: 'Doe' })
  @IsNotEmpty()
  @IsString()
  lastName: string;

  @ApiProperty({ description: 'User password', example: 'Strong password' })
  @IsNotEmpty()
  @IsString()
  password: string;
}
