/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { display, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

export class WindowUtility {
  private static isSet: boolean = false;
  private static windowStage: window.WindowStage;
  private static mainWindow: window.Window;

  public static setWindow(windowStage: window.WindowStage): void {
    WindowUtility.windowStage = windowStage;
    WindowUtility.mainWindow = windowStage.getMainWindowSync();
    WindowUtility.isSet = true;
  }

  public static getWindowStage(): window.WindowStage {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[getWindowStage] WindowUtil not set');
    }
    return WindowUtility.windowStage;
  }

  public static getWindow(): window.Window {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[getWindow] WindowUtil not set');
    }
    return WindowUtility.mainWindow;
  }

  public static getWindowWidth(): number {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000,'WindowUtility', '[getWindowWidth] WindowUtil not set');
    }
    return px2vp(WindowUtility.mainWindow.getWindowProperties().windowRect.width);
  }

  public static getWindowHeight(): number {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[getWindowHeight] WindowUtil not set');
    }
    return px2vp(WindowUtility.mainWindow.getWindowProperties().windowRect.height);
  }

  public static getStatusHeight(): number {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[getStatusHeight] WindowUtil not set');
    }
    return px2vp(WindowUtility.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height);
  }

  public static getNavHeight(): number {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[getNavHeight] WindowUtil not set');
    }
    return px2vp(WindowUtility.mainWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
      .bottomRect.height);
  }

  public static setWindowOrientation(context: Context, orientation: window.Orientation) {
    // context: getContext(this)
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[setWindowColorDeep] WindowUtil not set');
      return;
    }
    // getLastWindow gets the topmost subwindow in the current application. If no subwindow is applied, it returns to the main application window.
    window.getLastWindow(context).then((lastWindow) => {
      lastWindow.setPreferredOrientation(orientation).then(() => {
        hilog.info(0x0000, 'WindowUtility', `setPreferredOrientation to ${orientation} success`);
      }).catch((error: BusinessError) => {
        hilog.info(0x0000, 'WindowUtility', `setPreferredOrientation to ${orientation} failure` + JSON.stringify(error));
      })
    }).catch((error: BusinessError) => {
      hilog.info(0x0000, 'WindowUtility', 'getLastWindow error: ' + JSON.stringify(error));
    })
  }

  public static getDisplayOrientation() {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[setWindowColorDeep] WindowUtil not set');
      return;
    }
    let orientation: display.Orientation = display.getDefaultDisplaySync().orientation
    switch (orientation) {
      case display.Orientation.PORTRAIT:
        hilog.info(0x0000, 'WindowUtility', '[getDisplayOrientation] display.Orientation.PORTRAIT');
        break;
      case display.Orientation.LANDSCAPE:
        hilog.info(0x0000, 'WindowUtility', '[getDisplayOrientation] display.Orientation.LANDSCAPE');
        break;
      case display.Orientation.PORTRAIT_INVERTED:
        hilog.info(0x0000, 'WindowUtility', '[getDisplayOrientation] display.Orientation.PORTRAIT_INVERTED');
        break;
      case display.Orientation.LANDSCAPE_INVERTED:
        hilog.info(0x0000, 'WindowUtility', '[getDisplayOrientation] display.Orientation.LANDSCAPE_INVERTED');
        break;
      default:
        hilog.info(0x0000, 'WindowUtility', `[getDisplayOrientation] ${orientation}`);
    }
  }

  public static getWindowOrientation() {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[setWindowColorDeep] WindowUtil not set');
      return;
    }
    let orientation: window.Orientation = WindowUtility.mainWindow.getPreferredOrientation()

    switch (orientation) {
      case window.Orientation.PORTRAIT:
        hilog.info(0x0000, 'WindowUtility', '[getWindowOrientation] window.Orientation.PORTRAIT');
        break;
      case window.Orientation.LANDSCAPE:
        hilog.info(0x0000, 'WindowUtility', '[getWindowOrientation] window.Orientation.LANDSCAPE');
        break;
      case window.Orientation.PORTRAIT_INVERTED:
        hilog.info(0x0000, 'WindowUtility', '[getWindowOrientation] window.Orientation.PORTRAIT_INVERTED');
        break;
      case window.Orientation.LANDSCAPE_INVERTED:
        hilog.info(0x0000, 'WindowUtility', '[getWindowOrientation] window.Orientation.LANDSCAPE_INVERTED');
        break;
      default:
        hilog.info(0x0000, 'WindowUtility', `[getWindowOrientation] ${orientation}`);
    }
  }

  public static setWindowColorDeep() {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[setWindowColorDeep] WindowUtil not set');
      return;
    }
    let sysBarProps: window.SystemBarProperties = {
      statusBarColor: '#000000',
      navigationBarColor: '#000000',
      statusBarContentColor: '#ffffff',
      navigationBarContentColor: '#ffffff'
    };
    WindowUtility.mainWindow.setWindowSystemBarProperties(sysBarProps);
    try {
      WindowUtility.mainWindow.setWindowBackgroundColor('#000000');
    } catch (err) {
      hilog.error(0x0000, 'WindowUtility',
        '[setWindowColorDeep] Failed to setWindowBackgroundColor. Cause: ' + JSON.stringify(err));
    }
  }

  public static setWindowColorWhite() {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[setWindowColorWhite] WindowUtil not set');
      return;
    }
    let sysBarProps: window.SystemBarProperties = {
      statusBarColor: '#ffffff',
      navigationBarColor: '#ffffff',
      statusBarContentColor: '#000000',
      navigationBarContentColor: '#000000'
    };
    WindowUtility.mainWindow.setWindowSystemBarProperties(sysBarProps);
    try {
      WindowUtility.mainWindow.setWindowBackgroundColor('#ffffff');
    } catch (err) {
      hilog.error(0x0000, 'WindowUtility',
        '[setWindowColorWhite] Failed to setWindowBackgroundColor. Cause: ' + JSON.stringify(err));
    }
  }

  public static setWindowFullScreen(isLayoutFullScreen: boolean) {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[setWindowFullScreen] WindowUtil not set');
      return;
    }

    WindowUtility.mainWindow.setWindowLayoutFullScreen(isLayoutFullScreen)
      .then(() => {
        hilog.info(0x0000, 'WindowUtility', 'Succeeded in setting the window layout to full-screen mode.');
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, 'WindowUtility',
          `Failed to set the window layout to full-screen mode. Code is ${err.code}, message is ${err.message}`);
      });
  }

  public static SetSpecificSystemBarEnabled(name: window.SpecificSystemBar, enable: boolean,
    enableAnimation: boolean) {
    if (!WindowUtility.isSet) {
      hilog.info(0x0000, 'WindowUtility', '[setWindowSpecificSystemBarEnabled] WindowUtil not set');
      return;
    }
    let info = 'invisible';
    if (enable) {
      info = 'visible';
    }
    if (canIUse('SystemCapability.Window.SessionManager'))
      WindowUtility.mainWindow.setSpecificSystemBarEnabled(name, enable, enableAnimation)
        .then(() => {
          hilog.info(0x0000, 'WindowUtility', `Succeeded in setting the ${name} bar to be ${info}.`);
        })
        .catch((err: BusinessError) => {
          hilog.error(0x0000, 'WindowUtility',
            `Failed to set the ${name} bar to be invisible. Code is ${err.code}, message is ${err.message}`);
        });
  }
}




