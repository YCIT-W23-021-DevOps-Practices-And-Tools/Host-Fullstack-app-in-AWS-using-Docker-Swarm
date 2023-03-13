import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as basicAuth from 'express-basic-auth';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const users = {};
  users[`${process.env.API_USER_NAME}`] = process.env.API_PASSWORD;
  app.use(
    basicAuth({
      users: users,
    }),
  );
  await app.listen(3000);
}
bootstrap();
