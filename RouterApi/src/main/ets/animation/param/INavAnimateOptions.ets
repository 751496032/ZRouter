/**
 * @author: HHBin
 * @date: 2024-11-23
 * @desc:
 */
import NavAnimateStatus from '../const/NavAnimateStatus';
import { NavAnimationModifier } from '../modifier/NavAnimationModifier';

export interface INavAnimateOptions {
  // 是否是上一页的转场
  _isBeforePage: boolean

  updateModifier(modifier: NavAnimationModifier, isStart: boolean, status: NavAnimateStatus): void;
}
