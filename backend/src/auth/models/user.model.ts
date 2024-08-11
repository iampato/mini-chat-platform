import { User } from '../entities/user.entity';

export interface UserModel {
  id: string;
  phone: string;
  firstName: string;
  lastName: string;
  bio: string;
  lastLogin: Date;
  created: Date;
  updated: Date;
}

export function userEntityToModel(user: User): UserModel {
  return {
    id: user.id,
    firstName: user.firstName,
    lastName: user.lastName,
    bio: user.bio,
    phone: user.phone,
    created: user.created,
    updated: user.updated,
    lastLogin: user.lastLogin,
  };
}
