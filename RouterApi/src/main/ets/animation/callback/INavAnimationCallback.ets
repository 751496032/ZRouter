import { AnimateCallback } from '../NavAnimationMgr';
import { INavAnimationParam } from '../param/INavAnimationParam';

/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc: 路由动画转场回调
 */
export class INavAnimationCallback {
  /**
   * 动画属性参数
   */
  param?: INavAnimationParam
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
