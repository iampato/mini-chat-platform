import { Module } from '@nestjs/common';
import { environmentValidationSchema } from './config.schema';
import { ConfigModule as NestConfigModule } from '@nestjs/config';
import { PsqlConfigService } from './service/psql-config.service';
import { JwtConfigService } from './service/jwt-config.service';
import { RedisConfigService } from './service/redis-config.service';

@Module({
  imports: [
    NestConfigModule.forRoot({
      isGlobal: true,
      envFilePath: [`.env.${process.env.ENV}`],
      validationSchema: environmentValidationSchema,
    }),
  ],
  providers: [PsqlConfigService, JwtConfigService, RedisConfigService],
  exports: [PsqlConfigService, JwtConfigService, RedisConfigService],
})
export class ConfigModule {}
