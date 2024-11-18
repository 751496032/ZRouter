import { AttributeUpdater } from '@kit.ArkUI'
import { AnimateCallback } from '../NavAnimationMgr'
import { INavSingleAnimationParam } from '../param/INavAnimationParam'

/**
 * @author: HHBin
 * @date: 2024-11-14
 * @desc: 导航动态属性设置
 */
export class NavAnimationModifier extends AttributeUpdater<NavDestinationAttribute, NavDestinationInterface> {
  callback: AnimateCallback | undefined
  isUpdate: boolean = true
  _translateOptions: TranslateOptions | undefined
  _scaleOptions: ScaleOptions | undefined
  _rotateOptions: RotateOptions | undefined
  _opacity: number | Resource | undefined

  public translate(value: TranslateOptions | undefined): NavAnimationModifier {
    if (value) {
      this.attribute?.translate(value)
    }
    return this
  }

  public scale(value: ScaleOptions | undefined): NavAnimationModifier {
    if (value) {
      this.attribute?.scale(value)
    }
    return this
  }

  public rotate(value: RotateOptions | undefined): NavAnimationModifier {
    if (value) {
      this.attribute?.rotate(value)
    }
    return this
  }

  public opacity(value: number | Resource | undefined): NavAnimationModifier {
    if (value) {
      this.attribute?.opacity(value)
    }
    return this
  }

  public update(param: INavSingleAnimationParam | undefined, onFinish?: (() => void )): NavAnimationModifier {
    if (param) {
      this.start(param)
      animateTo({
        duration: param?.animateParam?.duration,
        tempo: param?.animateParam?.tempo,
        curve: param?.animateParam?.curve,
        delay: param?.animateParam?.delay,
        iterations: param?.animateParam?.iterations,
        playMode: param?.animateParam?.playMode,
        finishCallbackType: param?.animateParam?.finishCallbackType,
        expectedFrameRateRange: param?.animateParam?.expectedFrameRateRange,
        onFinish: () => {
          if (param?.animateParam?.onFinish) {
            param?.animateParam.onFinish()
          }
          if (onFinish) {
            onFinish()
          }
        }
      }, () => {
        this.end( param)
      })
    }
    return this
  }

  private start(param: INavSingleAnimationParam | undefined) {
    if (param) {
      this
        .opacity(param.startOpacity)
        .translate(param.startTranslateOptions)
        .scale(param.startScaleOptions)
        .rotate(param.startRotateOptions)
    }
  }

  private end(param: INavSingleAnimationParam | undefined) {
    if (param) {
      this
        .opacity(param.endOpacity)
        .translate(param.endTranslateOptions)
        .scale(param.endScaleOptions)
        .rotate(param.endRotateOptions)
    }
  }
}