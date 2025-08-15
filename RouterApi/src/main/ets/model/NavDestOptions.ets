/**
 * @author: HZWei
 * @date: 2024/9/10
 * @desc:
 */
import { RedirectType } from './Const';
import { DEFAULT_STACK_NAME, ObjectOrNull, OnPopResultCallback } from './Model';
import { LaunchMode } from './LaunchMode';

export interface INavDestOptions<T> {
  /**
   * 是否启用动画
   */
  animated: boolean;
  /**
   * 启动模式
   */
  lunchMode: LaunchMode;
  /**
   * 携带的参数
   */
  params?: ObjectOrNull;
  /**
   * 导航栈名称
   */
  navStackName: string;
  /**
   * 是否在根视图监听返回结果
   * 如果在根视图监听返回结果，没有将listenPopResultOnRootView设置为true，则不会触发onPopListener
   */
  listenPopResultOnRootView?: boolean;
  /**
   * 返回结果监听
   */
  onPopListener?: OnPopResultCallback<T | ObjectOrNull>;
  /**
   * 重定向类型
   */
  redirectType?: RedirectType;
  /**
   * 是否将跳转参数的0和false转为字符串，默认false
   */
  isConvertJumpParamZeroAndFalseToString?: boolean;

  /**
   * 支持元服务跨模块hsp模块动态加载
   *
   */
  isMetaServiceHspEnabled?: boolean;

  /**
   * 模块名称,元服务hsp模块跳转需要使用
   */
  moduleName?: string;
}

export class NavDestOptionsImpl<T> implements INavDestOptions<T> {
  animated: boolean = true;
  lunchMode: LaunchMode = LaunchMode.STANDARD;
  navStackName: string = DEFAULT_STACK_NAME;
  redirectType: RedirectType = RedirectType.REPLACE;
  isConvertJumpParamZeroAndFalseToString: boolean = false;
  isMetaServiceHspEnabled: boolean = false;
}