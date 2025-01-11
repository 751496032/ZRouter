/**
 * @author: HZWei
 * @date: 2025/1/2
 * @desc:
 */
import { deviceInfo } from '@kit.BasicServicesKit';

export class DeviceUtil {
  private constructor() {
  }

  static getSdkVersion(): number {
    return deviceInfo.sdkApiVersion
  }

  static isSdkVersion11(): boolean {
    return DeviceUtil.getSdkVersion() === 11;
  }

  static isSdkVersion12(): boolean {
    return DeviceUtil.getSdkVersion() >= 12;
  }
}