import 'dotenv/config';
import * as Joi from '@hapi/joi';

export const environmentValidationSchema = Joi.object({
  ENV: Joi.string().valid(
    'development',
    'staging',
    'production',
    'test',
    'uat',
  ),
  // Mongo
  MONGO_DB_URL: Joi.string().required(),
  // Redis
  REDIS_HOST: Joi.string(),
  REDIS_PORT: Joi.number(),
  REDIS_PASSWORD: Joi.string().optional(),
  // postgres
  DATABASE_HOST: Joi.string().required(),
  DATABASE_PORT: Joi.number().required(),
  DATABASE_USER: Joi.string().optional(),
  DATABASE_PASSWORD: Joi.string().optional(),
  DATABASE_NAME: Joi.string().required(),
  // JWT
  JWT_SECRET: Joi.string().required(),
  JWT_EXPIRES_IN: Joi.string().required(),
});
