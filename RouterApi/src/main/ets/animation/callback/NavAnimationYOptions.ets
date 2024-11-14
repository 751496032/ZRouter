/**
 * @author: HHBin
 * @date: 2024-11-14
 * @desc:
 */
import { AnimateCallback } from '../NavAnimationMgr';
import { NavDestinationModifier } from '@ohos.arkui.modifier';
import { INavAnimationOptions } from './INavAnimationOptions';

// 暂时
export class NavAnimationYOptions extends INavAnimationOptions {
  constructor(update: ((options: NavDestinationModifier) => void) | undefined) {
    super(update)
  }

  timeout? = 200
  update?: ((options: NavDestinationModifier) => void) | undefined
  startCallback? =
    (mgr: AnimateCallback, isPush: boolean, isExit: boolean) => {
      if (isPush) {
        mgr.modifier?.translate({ y: '100%' })
      } else {
        mgr.modifier?.translate({ y: '0' })
      }
    }
  endCallback? = (mgr: AnimateCallback, isPush: boolean, isExit: boolean) => {
    if (isPush) {
      mgr.modifier?.translate({ y: '0' })
    } else {
      mgr.modifier?.translate({ y: '100%' })
    }
  }
  onFinish? = (mgr: AnimateCallback, isPush: boolean, isExit: boolean) => {
    mgr.modifier?.translate({ y: '0' })
  }
  interactiveCallback? = (mgr: AnimateCallback, operation: NavigationOperation) => {
    if (operation == NavigationOperation.PUSH) {
      mgr.modifier?.translate({ y: '100%' })
      animateTo({
        duration: 1000,
        onFinish: () => {
          mgr.modifier?.translate({ y: '0' })
        }
      }, () => {
        mgr.modifier?.translate({ y: '0' })
      })
    } else {
      mgr.modifier?.translate({ y: '0' })
      animateTo({
        duration: 1000,
        onFinish: () => {
          mgr.modifier?.translate({ y: '0' })
        }
      }, () => {
        mgr.modifier?.translate({ y: '100%' })
      })
    }
  }
}