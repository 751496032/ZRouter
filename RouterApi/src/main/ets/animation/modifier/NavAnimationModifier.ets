import { NavDestinationModifier } from "@kit.ArkUI"
import { AnimateCallback } from "../NavAnimationMgr"

/**
 * @author: HHBin
 * @date: 2024-11-14
 * @desc: 导航动态属性设置
 */
export class NavAnimationModifier extends NavDestinationModifier {
  callback: AnimateCallback | undefined
  translateOptions: TranslateOptions | undefined
  scaleOptions: ScaleOptions | undefined
  rotateOptions: RotateOptions | undefined
  transitionOptions: TransitionOptions | TransitionEffect | undefined

  constructor(callback: AnimateCallback) {
    super()
    this.callback = callback
  }

  translate(value: TranslateOptions): NavDestinationAttribute {
    this.translateOptions = value
    if (this.callback?.update) {
      this.callback.update(this)
    }
    return this
  }

  scale(value: ScaleOptions): NavDestinationAttribute {
    this.scaleOptions = value
    if (this.callback?.update) {
      this.callback.update(this)
    }
    return this
  }

  rotate(value: RotateOptions): NavDestinationAttribute {
    this.rotateOptions = value
    if (this.callback?.update) {
      this.callback.update(this)
    }
    return this
  }

  transition(value: TransitionOptions | TransitionEffect) {
    this.transitionOptions = value
    if (this.callback?.update) {
      this.callback.update(this)
    }
    return this
  }

  applyNormalAttribute(instance: NavDestinationAttribute): void {
    if (this.translateOptions) {
      instance.translate(this.translateOptions)
    }
    if (this.scaleOptions) {
      instance.scale(this.scaleOptions)
    }
    if (this.rotateOptions) {
      instance.rotate(this.rotateOptions)
    }
    if (this.transitionOptions) {
      instance.transition(this.transitionOptions)
    }
  }
}