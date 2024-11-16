import { AttributeUpdater } from '@kit.ArkUI'
import { AnimateCallback } from '../NavAnimationMgr'

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

  public update(): NavAnimationModifier {
    if (this.attribute) {
      if (this._translateOptions) {
        this.attribute.translate(this._translateOptions)
      }
      if (this._scaleOptions) {
        this.attribute.scale(this._scaleOptions)
      }
      if (this._rotateOptions) {
        this.attribute.rotate(this._rotateOptions)
      }
      if (this._opacity) {
        this.attribute.opacity(this._opacity)
      }
    }
    return this
  }
}