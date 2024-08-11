import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

interface PsqlConfig {
  host: string;
  port: number;
  user: string;
  password: string;
  database: string;
  appEnv: string;
}

@Injectable()
export class PsqlConfigService {
  constructor(private readonly configService: ConfigService) {}

  getConfig(): PsqlConfig {
    return {
      host: this.configService.get<string>('DATABASE_HOST'),
      port: this.configService.get<number>('DATABASE_PORT'),
      user: this.configService.get<string>('DATABASE_USER'),
      password: this.configService.get<string>('DATABASE_PASSWORD'),
      database: this.configService.get<string>('DATABASE_NAME'),
      appEnv: this.configService.get<string>('ENV'),
    };
  }
}
