import NavAnimateStatus from '../const/NavAnimateStatus';
import { NavAnimationModifier } from '../modifier/NavAnimationModifier';
import { INavAnimateOptions } from './INavAnimateOptions';

/**
 * @author: HHBin
 * @date: 2024-11-23
 * @desc: 平移动画
 */
export class TranslateAnimationOptions implements INavAnimateOptions {
  _options?: TranslateOptions
  _isBeforePage: boolean = false

  constructor(options: TranslateOptions, isBeforePage?: boolean) {
    this._options = options
    this._isBeforePage = isBeforePage ?? false
  }

  public updateModifier(modifier: NavAnimationModifier, isStart: boolean, status: NavAnimateStatus): void {
    switch (status) {
      case NavAnimateStatus.PUSH_ENTER:
        if (!this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.translate(this._options)
          } else {
            modifier.attribute?.translate({ x: 0, y: 0, z: 0 })
          }
        }
        break
      case NavAnimateStatus.POP_EXIT:
        if (!this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.translate({ x: 0, y: 0, z: 0 })
          } else {
            modifier.attribute?.translate(this._options)
          }
        }
        break
      case NavAnimateStatus.PUSH_EXIT:
        if (this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.translate({ x: 0, y: 0, z: 0 })
          } else {
            modifier.attribute?.translate(this._options)
          }
        }
        break
      case NavAnimateStatus.POP_ENTER:
        if (this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.translate(this._options)
          } else {
            modifier.attribute?.translate({ x: 0, y: 0, z: 0 })
          }
        }
        break
    }
  }
}