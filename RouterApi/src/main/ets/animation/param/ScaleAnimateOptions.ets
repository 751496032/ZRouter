import NavAnimateStatus from '../const/NavAnimateStatus';
import { NavAnimationModifier } from '../modifier/NavAnimationModifier';
import { INavAnimateOptions } from './INavAnimateOptions';

/**
 * @author: HHBin
 * @date: 2024-11-23
 * @desc: 缩放动画
 */
export class ScaleAnimateOptions implements INavAnimateOptions {
  _options?: ScaleOptions
  _isBeforePage: boolean = false

  constructor(options: ScaleOptions, isBeforePage?: boolean) {
    this._options = options
    this._isBeforePage = isBeforePage ?? false
  }

  public updateModifier(modifier: NavAnimationModifier, isStart: boolean, status: NavAnimateStatus): void {
    switch (status) {
      case NavAnimateStatus.PUSH_ENTER:
        if (!this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.scale(this._options)
          } else {
            modifier.attribute?.scale({
              x: 1,
              y: 1,
              z: 1,
              centerX: this._options?.centerX,
              centerY: this._options?.centerY,
            })
          }
        }
        break
      case NavAnimateStatus.POP_EXIT:
        if (!this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.scale({
              x: 1,
              y: 1,
              z: 1,
              centerX: this._options?.centerX,
              centerY: this._options?.centerY
            })
          } else {
            modifier.attribute?.scale(this._options)
          }
        }
        break
      case NavAnimateStatus.PUSH_EXIT:
        if (this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.scale({
              x: 1,
              y: 1,
              z: 1,
              centerX: this._options?.centerX,
              centerY: this._options?.centerY
            })
          } else {
            modifier.attribute?.scale(this._options)
          }
        }
        break
      case NavAnimateStatus.POP_ENTER:
        if (this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.scale(this._options)
          } else {
            modifier.attribute?.scale({
              x: 1,
              y: 1,
              z: 1,
              centerX: this._options?.centerX,
              centerY: this._options?.centerY
            })
          }
        }
        break
    }
  }
}
