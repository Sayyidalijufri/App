/**
 * TypeScript type definitions for splash screen components
 */

export interface SplashScreenConfig {
  backgroundColor: string;
  animationType: 'none' | 'crossDissolve' | 'fade';
  initialDelay: number;
  fadeDuration: number;
  colorSpace: 'sRGB' | 'displayP3';
}

export interface NetworkCondition {
  type: 'fast' | 'slow' | 'offline';
  latency: number;
  downloadThroughput: number;
  uploadThroughput: number;
}

export interface ScreenshotData {
  timestamp: number;
  colorHex: string;
  isConsistent: boolean;
  platform: string;
}

export interface ColorValidation {
  isConsistent: boolean;
  inconsistentFrames: number[];
  colorVariations: string[];
  expectedColor: string;
}

export interface PlatformSupport {
  ios: {
    standalone: boolean;
    hybridApp: boolean;
    minVersion: string;
  };
  android: {
    standalone: boolean;
    hybridApp: boolean;
    minVersion: string;
  };
  web: {
    chrome: boolean;
    safari: boolean;
    firefox: boolean;
  };
  desktop: {
    windows: boolean;
    macos: boolean;
    linux: boolean;
  };
}

export interface TestScenario {
  name: string;
  description: string;
  networkCondition: NetworkCondition;
  expectedDuration: number;
  platform: string;
}
