/**
 * @author: HZWei
 * @date: 2025/4/19
 * @desc:
 */

import { ToastUtils } from "@hzw/common_library";
import { common } from "@kit.AbilityKit";

// 使用闭包封装 backPressTime，避免全局变量污染
const onBackPress = (): ((context?: common.UIAbilityContext) => boolean) => {
  let backPressTime: number = 0;
  const DOUBLE_PRESS_INTERVAL = 2000;

  return (context?: common.UIAbilityContext): boolean => {
    const currentTime = Date.now();
    const isDoublePress = currentTime - backPressTime < DOUBLE_PRESS_INTERVAL;

    if (isDoublePress) {
      if (context) {
        context.terminateSelf();
      }
      return false;
    }

    backPressTime = currentTime;
    ToastUtils.show("再按一次退出");
    return true;
  };
};

export default onBackPress();