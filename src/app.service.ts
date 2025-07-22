import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): any {
    return {
      message: '🎉 OMPeak Project API is running!',
      service: 'NestJS Backend',
      version: '1.0.0',
      environment: process.env.NODE_ENV || 'development',
      timestamp: new Date().toISOString(),
      endpoints: {
        status: '/api/status',
        health: '/api/health'
      }
    };
  }

  getHealth(): any {
    return {
      status: 'OK',
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
      memory: process.memoryUsage(),
      version: process.version
    };
  }

  getStatus(): any {
    return {
      status: 'active',
      message: 'Service is running normally',
      deployment: {
        lastDeploy: new Date().toISOString(),
        server: 'Alibaba Cloud',
        environment: process.env.NODE_ENV || 'development'
      }
    };
  }
}
