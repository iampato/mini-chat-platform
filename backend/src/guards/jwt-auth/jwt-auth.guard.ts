import {
  Injectable,
  CanActivate,
  ExecutionContext,
  HttpStatus,
  HttpException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private readonly jwtService: JwtService) {}

  canActivate(context: ExecutionContext): boolean {
    try {
      const request = context.switchToHttp().getRequest();
      const authHeader = request.headers.authorization;

      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        throw new HttpException('Unauthorized access', HttpStatus.UNAUTHORIZED);
      }

      const token = authHeader.split(' ')[1];
      // console.log('Token', token);
      const decoded = this.jwtService.verify(token);
      if (!decoded || typeof decoded === 'string') {
        throw new UnauthorizedException('Invalid access token');
      }
      request.user = decoded; // Attach decoded user data to the request object

      return true;
    } catch (error) {
      console.log('Error', error);
      throw new HttpException('Invalid token', HttpStatus.UNAUTHORIZED);
    }
  }
}
