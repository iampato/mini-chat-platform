import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { ChatModule } from './chat/chat.module';
import { ContactModule } from './contact/contact.module';
import { PresenceModule } from './presence/presence.module';
import { ConfigModule } from './config/config.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PsqlConfigService } from 'src/config/service/psql-config.service';
import { getAppDataSource } from 'src/typeorm.config';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: PsqlConfigService) => {
        return getAppDataSource(configService);
      },
      inject: [PsqlConfigService],
    }),
    AuthModule,
    ChatModule,
    ContactModule,
    PresenceModule,
    ConfigModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
