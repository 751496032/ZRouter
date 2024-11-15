import { AnimateCallback } from '../NavAnimationMgr';
import { NavAnimationModifier } from '../modifier/NavAnimationModifier';
import { INavAnimationParam } from '../param/INavAnimationParam';

/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc: 路由动画转场回调
 */
export class INavAnimationCallback {
  constructor(update: ((modifier: NavAnimationModifier) => void) | undefined) {
    this.update = update
  }

  /**
   * 更新modifier动态属性设置
   */
  update?: (modifier: NavAnimationModifier) => void;
  /**
   * 注册页面的唯一id，不用自己设置
   */
  name?: string
  /**
   * 用于导航动态属性设置，不用自己设置
   */
  modifier?: NavAnimationModifier
  /**
   * 动画属性参数
   */
  param?: INavAnimationParam
  /**
   * 转场结束的超时时间
   */
  timeout?: number
  /**
   * 用来设置动画开始时页面的状态
   */
  startCallback?: (callback: AnimateCallback, operation: boolean, isExit: boolean) => void;
  /**
   * 用来设置动画结束时页面的状态
   */
  endCallback?: (callback: AnimateCallback, operation: boolean, isExit: boolean) => void;
  /**
   * 用来执行动画结束后页面的其他操作
   */
  onFinish?: (callback: AnimateCallback, operation: boolean, isExit: boolean) => void;
  /**
   * 注册的可交互转场的动效
   */
  interactiveCallback?: (callback: AnimateCallback, operation: NavigationOperation) => void;
}
