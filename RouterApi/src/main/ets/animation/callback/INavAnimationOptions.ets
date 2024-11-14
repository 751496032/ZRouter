import { AnimateCallback } from '../NavAnimationMgr';
import { NavDestinationModifier } from '@kit.ArkUI';

/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc: 路由动画转场配置
 */
export class INavAnimationOptions {

  constructor(update: ((options: NavDestinationModifier) => void) | undefined) {
    this.update = update
  }

  /**
   * 注册页面的唯一id，不用自己设置
   */
  name?: string
  /**
   * 用于导航动态属性设置，不用自己设置
   */
  modifier?: NavDestinationModifier
  /**
   * 转场结束的超时时间
   */
  timeout?: number
  /**
   * 用来设置动画开始时页面的状态
   */
  startCallback?: (options: AnimateCallback, operation: boolean, isExit: boolean) => void;

  /**
   * 用来设置动画结束时页面的状态
   */
  endCallback?: (options: AnimateCallback, operation: boolean, isExit: boolean) => void;

  /**
   * 用来执行动画结束后页面的其他操作
   */
  onFinish?: (options: AnimateCallback, operation: boolean, isExit: boolean) => void;

  /**
   * 更新modifier动态属性设置
   */
  update?: (options: NavDestinationModifier) => void;

  /**
   * 注册的可交互转场的动效
   */
  interactiveCallback?: (options: AnimateCallback, operation: NavigationOperation) => void;

}
