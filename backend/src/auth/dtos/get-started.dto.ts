import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';
import { IsValidPhoneNumber } from 'src/decorators/phone-validator.decorator';

export class GetStartedDto {
  @ApiProperty({ description: 'User phone number', example: '+1234567890' })
  @IsNotEmpty()
  @IsValidPhoneNumber({ message: 'phoneNumber must be a valid phone number' })
  phone: string;
}
