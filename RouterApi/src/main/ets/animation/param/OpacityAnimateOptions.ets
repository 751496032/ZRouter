import NavAnimateStatus from '../const/NavAnimateStatus';
import { NavAnimationModifier } from '../modifier/NavAnimationModifier';
import { INavAnimateOptions } from './INavAnimateOptions';

/**
 * @author: HHBin
 * @date: 2024-11-23
 * @desc: 渐变动画
 */
export class OpacityAnimateOptions implements INavAnimateOptions {
  _options?: number | Resource;
  _isBeforePage: boolean = false

  constructor(options: number | Resource, isBeforePage?: boolean) {
    this._options = options
    this._isBeforePage = isBeforePage ?? false
  }

  public updateModifier(modifier: NavAnimationModifier, isStart: boolean, status: NavAnimateStatus): void {
    switch (status) {
      case NavAnimateStatus.PUSH_ENTER:
        if (!this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.opacity(this._options)
          } else {
            modifier.attribute?.opacity(1)
          }
        }
        break
      case NavAnimateStatus.POP_EXIT:
        if (!this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.opacity(1)
          } else {
            modifier.attribute?.opacity(this._options)
          }
        }
        break
      case NavAnimateStatus.PUSH_EXIT:
        if (this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.opacity(1)
          } else {
            modifier.attribute?.opacity(this._options)
          }
        }
        break
      case NavAnimateStatus.POP_ENTER:
        if (this._isBeforePage) {
          if (isStart) {
            modifier.attribute?.opacity(this._options)
          } else {
            modifier.attribute?.opacity(1)
          }
        }
        break
    }
  }
}