import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { Logger } from '@hzw/logger';
import { RouterConstants } from 'common_library';

export default class HapAAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'HapAAbility', '%{public}s', 'Ability onCreate');
    Logger.i(want)
    Logger.d(want.parameters?.route)
    // let eventhub = this.context.eventHub;
    // eventhub.emit(RouterConstants.EVENT_HAP_LAUNCH_ROUTER, want.parameters?.route)
    AppStorage.setOrCreate(RouterConstants.EVENT_HAP_LAUNCH_ROUTER, want.parameters?.route)
  }

  onDestroy(): void {
    hilog.info(0x0000, 'HapAAbility', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'HapAAbility', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(0x0000, 'HapAAbility', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'HapAAbility', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'HapAAbility', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'HapAAbility', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'HapAAbility', '%{public}s', 'Ability onBackground');
  }
}
