/**
 * @author: HHBin
 * @date: 2024-11-14
 * @desc: 动画转场参数
 */
import { NavAnimationModifier } from '../modifier/NavAnimationModifier';

export interface INavAnimationParam {
  timeout?: number
  animateParam?: AnimateParam
  update: (modifier: NavAnimationModifier) => void;
  startTranslateOptions?: TranslateOptions
  endTranslateOptions?: TranslateOptions
  startScaleOptions?: ScaleOptions
  endScaleOptions?: ScaleOptions
  startRotateOptions?: RotateOptions
  endRotateOptions?: RotateOptions
  startOpacity?: number | Resource | undefined
  endOpacity?: number | Resource | undefined
}