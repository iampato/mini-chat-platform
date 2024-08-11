import { UserModel } from './user.model';

export interface LoginModel {
  accessToken: string;
  refreshToken: string;
  user: UserModel;
}
