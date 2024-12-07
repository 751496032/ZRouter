import NavAnimateStatus from '../const/NavAnimateStatus';
import { NavAnimationModifier } from '../modifier/NavAnimationModifier';
import { INavAnimateOptions } from './INavAnimateOptions';

/**
 * @author: HHBin
 * @date: 2024-11-28
 * @desc: 模糊动画
 */
export class BlurAnimationOptions implements INavAnimateOptions {
  _blur?: number
  _options?: BlurOptions
  _isBeforePage: boolean = false

  constructor(blur: number, options?: BlurOptions, isBeforePage?: boolean) {
    this._blur = blur
    this._options = options
    this._isBeforePage = isBeforePage ?? false
  }

  public updateModifier(modifier: NavAnimationModifier, isStart: boolean, status: NavAnimateStatus): void {
    switch (status) {
      case NavAnimateStatus.PUSH_ENTER:
        if (!this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.blur(this._blur, this._options)
          } else {
            modifier.attribute?.blur(0)
          }
        }
        break
      case NavAnimateStatus.POP_EXIT:
        if (!this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.blur(0)
          } else {
            modifier.attribute?.blur(this._blur, this._options)
          }
        }
        break
      case NavAnimateStatus.PUSH_EXIT:
        if (this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.blur(0)
          } else {
            modifier.attribute?.blur(this._blur, this._options)
          }
        }
        break
      case NavAnimateStatus.POP_ENTER:
        if (this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.blur(this._blur, this._options)
          } else {
            modifier.attribute?.blur(0)
          }
        }
        break
    }
  }
}