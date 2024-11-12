/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc: 路由动画转场配置
 */
export class NavAnimationOptions {
  /**
   * 注册页面的唯一id
   */
  name?: string
  /**
   * 转场结束的超时时间
   */
  timeout?: number
  /**
   * 用来设置动画开始时页面的状态
   */
  startCallback?: (options: TranslateOptions, operation: boolean, isExit: boolean) => void;
  /**
   * 用来设置动画结束时页面的状态
   */
  endCallback?: (options: TranslateOptions, operation: boolean, isExit: boolean) => void;
  /**
   * 用来执行动画结束后页面的其他操作
   */
  onFinish?: (options: TranslateOptions, operation: boolean, isExit: boolean) => void;
  /**
   * 更新坐标
   */
  update?: (options: TranslateOptions) => void;
  /**
   * 注册的可交互转场的动效
   */
  interactiveCallback?: (options: TranslateOptions, operation: NavigationOperation) => void;
}
