import { NavAnimationModifier } from '../modifier/NavAnimationModifier';
import { INavAnimationParam } from './INavAnimationParam';

/**
 * @author: HHBin
 * @date: 2024-11-15
 * @desc: 空的动画转场参数
 */
export class EmptyNavAnimationParam implements INavAnimationParam {
  update: (modifier: NavAnimationModifier) => void = () => {
  }
}