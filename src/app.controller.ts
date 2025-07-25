import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): any {
    return this.appService.getHello();
  }

  @Get('health')
  getHealth(): any {
    return this.appService.getHealth();
  }

  @Get('status')
  getStatus(): any {
    return this.appService.getStatus();
  }
}
