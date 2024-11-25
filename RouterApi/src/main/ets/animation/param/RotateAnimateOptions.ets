import NavAnimateStatus from '../const/NavAnimateStatus';
import { NavAnimationModifier } from '../modifier/NavAnimationModifier';
import { INavAnimateOptions } from './INavAnimateOptions';

/**
 * @author: HHBin
 * @date: 2024-11-23
 * @desc: 旋转动画
 */
export class RotateAnimateOptions implements INavAnimateOptions {
  _options?: RotateOptions;
  _isBeforePage: boolean = false

  constructor(options: RotateOptions, isBeforePage?: boolean) {
    this._options = options
    this._isBeforePage = isBeforePage ?? false
  }

  public updateModifier(modifier: NavAnimationModifier, isStart: boolean, status: NavAnimateStatus): void {
    switch (status) {
      case NavAnimateStatus.PUSH_ENTER:
        if (!this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.rotate(this._options)
          } else {
            modifier.attribute?.rotate({
              x: 0,
              y: 0,
              z: 0,
              centerX: this._options?.centerX,
              centerY: this._options?.centerY,
              centerZ: this._options?.centerZ,
              perspective: 0,
              angle: 0
            })
          }
        }
        break
      case NavAnimateStatus.POP_EXIT:
        if (!this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.rotate({
              x: 0,
              y: 0,
              z: 0,
              centerX: this._options?.centerX,
              centerY: this._options?.centerY,
              centerZ: this._options?.centerZ,
              perspective: 0,
              angle: 0
            })
          } else {
            modifier.attribute?.rotate(this._options)
          }
        }
        break
      case NavAnimateStatus.PUSH_EXIT:
        if (this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.rotate({
              x: 0,
              y: 0,
              z: 0,
              centerX: this._options?.centerX,
              centerY: this._options?.centerY,
              centerZ: this._options?.centerZ,
              perspective: 0,
              angle: 0
            })
          } else {
            modifier.attribute?.rotate(this._options)
          }
        }
        break
      case NavAnimateStatus.POP_ENTER:
        if (this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.rotate(this._options)
          } else {
            modifier.attribute?.rotate({
              x: 0,
              y: 0,
              z: 0,
              centerX: this._options?.centerX,
              centerY: this._options?.centerY,
              centerZ: this._options?.centerZ,
              perspective: 0,
              angle: 0
            })
          }
        }
        break
    }
  }
}