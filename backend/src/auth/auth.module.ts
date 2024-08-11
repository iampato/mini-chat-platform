import { Module, OnModuleInit } from '@nestjs/common';
import { ThrottlerStorageRedisService } from 'nestjs-throttler-storage-redis';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { RedisConfigService } from 'src/config/service/redis-config.service';
import { ConfigModule } from 'src/config/config.module';
import Redis from 'ioredis';
import { APP_GUARD } from '@nestjs/core';
import { UserService } from './service/user.service';
import { AuthService } from './service/auth.service';
import { RequestContextModule } from 'nestjs-request-context';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { JwtModule } from '@nestjs/jwt';
import { JwtConfigService } from 'src/config/service/jwt-config.service';
import { AuthController } from './controllers/auth.controller';
import { UserController } from './controllers/user.controller';

@Module({
  imports: [
    RequestContextModule,
    TypeOrmModule.forFeature([User]),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      inject: [JwtConfigService],
      useFactory: (config: JwtConfigService) => {
        const { secret, expiresIn } = config.getConfig();
        return {
          secret,
          signOptions: { expiresIn },
        };
      },
    }),
    ThrottlerModule.forRootAsync({
      imports: [ConfigModule],
      inject: [RedisConfigService],
      useFactory: (configService: RedisConfigService) => {
        const { host, port, username, password } = configService.getConfig();
        return {
          throttlers: [
            {
              ttl: 120000,
              limit: 5,
            },
          ],
          storage: new ThrottlerStorageRedisService(
            new Redis({
              port: port,
              host: host,
              username: username,
              ...(password && { password }),
            }),
          ),
        };
      },
    }),
  ],
  controllers: [AuthController, UserController],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    UserService,
    AuthService,
  ],
  exports: [UserService, AuthService],
})
export class AuthModule implements OnModuleInit {
  constructor(private readonly userService: UserService) {}

  async onModuleInit() {
    try {
      await this.userService.createDefaultUserIfNoneExists();
    } catch (error) {}
  }
}
