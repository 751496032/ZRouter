/**
 * @author: HHBin
 * @date: 2024-11-14
 * @desc: 默认路由动画转场回调
 */
import { AnimateCallback } from '../NavAnimationMgr';
import { INavAnimationCallback } from './INavAnimationCallback';
import { NavAnimationModifier } from '../modifier/NavAnimationModifier';

export class NavAnimationCallback extends INavAnimationCallback {
  update?: ((modifier: NavAnimationModifier) => void) | undefined
  startCallback? =
    (callback: AnimateCallback, isPush: boolean, isExit: boolean) => {
      if (isPush) {
        this.start(callback)
      } else {
        this.end(callback)
      }
    }
  endCallback? = (callback: AnimateCallback, isPush: boolean, isExit: boolean) => {
    if (isPush) {
      this.end(callback)
    } else {
      this.start(callback)
    }
  }
  onFinish? = (callback: AnimateCallback, isPush: boolean, isExit: boolean) => {
    this.end(callback)
  }
  interactiveCallback? = (callback: AnimateCallback, operation: NavigationOperation) => {
    const animParam = callback.param.animateParam
    animParam?.onFinish
    if (operation == NavigationOperation.PUSH) {
      this.start(callback)
      animateTo({
        duration: animParam?.duration,
        tempo: animParam?.tempo,
        curve: animParam?.curve,
        delay: animParam?.delay,
        iterations: animParam?.iterations,
        playMode: animParam?.playMode,
        finishCallbackType: animParam?.finishCallbackType,
        expectedFrameRateRange: animParam?.expectedFrameRateRange,
        onFinish: () => {
          this.end(callback)
          if (animParam?.onFinish) {
            animParam.onFinish()
          }
        }
      }, () => {
        this.end(callback)
      })
    } else {
      this.end(callback)
      animateTo({
        duration: animParam?.duration,
        tempo: animParam?.tempo,
        curve: animParam?.curve,
        delay: animParam?.delay,
        iterations: animParam?.iterations,
        playMode: animParam?.playMode,
        finishCallbackType: animParam?.finishCallbackType,
        expectedFrameRateRange: animParam?.expectedFrameRateRange,
        onFinish: () => {
          this.start(callback)
          if (animParam?.onFinish) {
            animParam.onFinish()
          }
        }
      }, () => {
        this.start(callback)
      })
    }
  }

  public start(callback: AnimateCallback) {
    callback.modifier
      .opacity(callback.param.startOpacity)
      .translate(callback.param.startTranslateOptions)
      .scale(callback.param.startScaleOptions)
      .rotate(callback.param.startRotateOptions)
      .update()
  }

  public end(callback: AnimateCallback) {
    callback.modifier
      .opacity(callback.param.endOpacity)
      .translate(callback.param.endTranslateOptions)
      .scale(callback.param.endScaleOptions)
      .rotate(callback.param.endRotateOptions)
      .update()
  }
}