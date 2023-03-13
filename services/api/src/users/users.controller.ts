import {
  Controller,
  Delete,
  Get,
  Param,
  Patch,
  Put,
  Request,
} from '@nestjs/common';

@Controller('users')
export class UsersController {
  @Put('/')
  async createAUser(@Request() req) {
    const body = req.body;
    const createdUserRaw = await fetch(
      `${process.env.MICROSERVICE1_DOCKER_ENDPOINT}/user`,
      {
        method: 'put',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
      },
    );
    const createdUser = await createdUserRaw.json();

    return createdUser;
  }

  @Get('/')
  async getAllUsers(@Request() req) {
    const usersRaw = await fetch(
      `${process.env.MICROSERVICE2_DOCKER_ENDPOINT}/users`,
      {
        method: 'get',
      },
    );
    const users = await usersRaw.json();

    return users;
  }

  @Get('/:user_id')
  async getUserById(@Param('user_id') user_id) {
    const userRaw = await fetch(
      `${process.env.MICROSERVICE2_DOCKER_ENDPOINT}/users/${user_id}`,
      {
        method: 'get',
      },
    );
    const user = await userRaw.json();

    return user;
  }

  @Patch('/:user_id')
  async updateUserById(@Request() req, @Param('user_id') user_id) {
    const body = req.body;
    const newBody = {
      id: parseInt(user_id),
      ...body,
    };
    const updatedUserRaw = await fetch(
      `${process.env.MICROSERVICE1_DOCKER_ENDPOINT}/user`,
      {
        method: 'PATCH',
        headers: {
          Accept: 'application/json',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(newBody),
      },
    );
    const updatedUser = await updatedUserRaw.json();

    return updatedUser;
  }

  @Delete('/:user_id')
  async deleteUserById(@Param('user_id') user_id) {
    const userRaw = await fetch(
      `${process.env.MICROSERVICE2_DOCKER_ENDPOINT}/users/${user_id}`,
      {
        method: 'delete',
      },
    );
    const user = await userRaw.json();

    return user;
  }
}
