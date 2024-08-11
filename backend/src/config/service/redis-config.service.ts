import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

interface RedisConfig {
  host: string;
  port: number;
  username?: string;
  password?: string;
}
@Injectable()
export class RedisConfigService {
  constructor(private readonly configService: ConfigService) {}

  getConfig(): RedisConfig {
    return {
      host: this.configService.get<string>('REDIS_HOST'),
      port: this.configService.get<number>('REDIS_PORT'),
      username: 'default', // 'default
      password: this.configService.get<string>('REDIS_PASSWORD'),
    };
  }

  // return connnection string
  getRedisConnectionString(): string {
    const { host, port, password } = this.getConfig();
    return `redis://${host}:${port}${password ? `?password=${password}` : ''}`;
  }
}
