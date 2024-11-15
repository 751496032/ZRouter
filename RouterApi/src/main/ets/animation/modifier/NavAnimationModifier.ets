import { NavDestinationModifier } from "@kit.ArkUI"
import { AnimateCallback } from "../NavAnimationMgr"

/**
 * @author: HHBin
 * @date: 2024-11-14
 * @desc: 导航动态属性设置
 */
export class NavAnimationModifier extends NavDestinationModifier {
  callback: AnimateCallback | undefined
  isUpdate: boolean = true
  _translateOptions: TranslateOptions | undefined
  _scaleOptions: ScaleOptions | undefined
  _rotateOptions: RotateOptions | undefined
  _opacity: number | Resource | undefined

  public update(): NavAnimationModifier {
    if (this.callback?.update) {
      this.callback.update(this)
    }
    return this
  }

  public translate(value: TranslateOptions | undefined): NavAnimationModifier {
    this._translateOptions = value
    return this
  }

  public scale(value: ScaleOptions | undefined): NavAnimationModifier {
    this._scaleOptions = value
    return this
  }

  public rotate(value: RotateOptions | undefined): NavAnimationModifier {
    this._rotateOptions = value
    return this
  }

  public opacity(value: number | Resource | undefined): NavAnimationModifier {
    this._opacity = value
    return this
  }

  public applyNormalAttribute(instance: NavDestinationAttribute): void {
    if (this._translateOptions) {
      instance.translate(this._translateOptions)
    }
    if (this._scaleOptions) {
      instance.scale(this._scaleOptions)
    }
    if (this._rotateOptions) {
      instance.rotate(this._rotateOptions)
    }
    if (this._opacity) {
      instance.opacity(this._opacity)
    }
  }
}