import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { ChatModule } from './chat/chat.module';
import { ContactModule } from './contact/contact.module';
import { PresenceModule } from './presence/presence.module';
import { ConfigModule } from './config/config.module';

@Module({
  imports: [
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
