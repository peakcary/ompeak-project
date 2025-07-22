import { Test, TestingModule } from '@nestjs/testing';
import { AppController } from './app.controller';
import { AppService } from './app.service';

describe('AppController', () => {
  let appController: AppController;

  beforeEach(async () => {
    const app: TestingModule = await Test.createTestingModule({
      controllers: [AppController],
      providers: [AppService],
    }).compile();

    appController = app.get<AppController>(AppController);
  });

  describe('root', () => {
    it('should return application info object', () => {
      const result = appController.getHello();
      expect(result).toBeDefined();
      expect(result.message).toContain('OMPeak Project API is running');
      expect(result.service).toBe('NestJS Backend');
      expect(result.version).toBe('1.0.0');
    });
  });

  describe('health', () => {
    it('should return health status', () => {
      const result = appController.getHealth();
      expect(result).toBeDefined();
      expect(result.status).toBe('OK');
      expect(result.uptime).toBeDefined();
      expect(result.timestamp).toBeDefined();
    });
  });

  describe('status', () => {
    it('should return status information', () => {
      const result = appController.getStatus();
      expect(result).toBeDefined();
      expect(result.status).toBe('active');
      expect(result.message).toBe('Service is running normally');
      expect(result.deployment).toBeDefined();
    });
  });
});
