import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

interface JwtConfig {
  secret: string;
  expiresIn: string;
}
@Injectable()
export class JwtConfigService {
  constructor(private readonly configService: ConfigService) {}

  getConfig(): JwtConfig {
    return {
      secret: this.configService.get<string>('JWT_SECRET'),
      expiresIn: this.configService.get<string>('JWT_EXPIRES_IN'),
    };
  }
}
