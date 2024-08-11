import { PostgresConnectionOptions } from 'typeorm/driver/postgres/PostgresConnectionOptions';
import { PsqlConfigService } from './config/service/psql-config.service';
import { User } from './auth/entities/user.entity';

export function getAppDataSource(
  configService: PsqlConfigService,
): PostgresConnectionOptions {
  console.log('connecting...');
  const config = configService.getConfig();
  return {
    type: 'postgres',
    host: config.host,
    port: config.port,
    username: config.user,
    password: config.password,
    database: config.database,
    entities: [User],
    synchronize: true,
    ssl: ['production'].includes(config.appEnv) && {
      rejectUnauthorized: false,
    },
    // Run migrations automatically,
    // you can disable this if you prefer running migration manually.
    migrationsRun: true,
    logging: true,
    // logger: 'file',

    // allow both start:prod and start:dev to use migrations
    // __dirname is either dist or src folder, meaning either
    // the compiled js in prod or the ts in dev
    migrations: [__dirname + '/migrations/**/*{.ts,.js}'],
  };
}
