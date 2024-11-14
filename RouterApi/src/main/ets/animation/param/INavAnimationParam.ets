/**
 * @author: HHBin
 * @date: 2024-11-14
 * @desc: 动画转场参数
 */
import { NavDestinationModifier } from '@kit.ArkUI';
import { NavAnimationDirection } from '../NavSwipeDirection';

export interface INavAnimationParam {
  animateParam?: AnimateParam
  update: (options: NavDestinationModifier) => void;
  direction?: NavAnimationDirection
}