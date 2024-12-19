/**
 * @author: HZWei
 * @date: 2024/9/15
 * @desc:
 */
import { InterceptorInfo, InterceptorInfoOrNull } from '../model/Model';

export interface IInterceptor {
  process: (context: InterceptorInfo) => InterceptorInfoOrNull;
  priority: number;
}

export interface IGlobalNavigateInterceptor {
  /**
   * Navigation根视图显示时回调
   * @param fromContext
   */
  onRootWillShow?: (fromContext: NavDestinationContext) => void;

  /**
   * 页面显示时回调
   * @param fromContext
   * @param toContext
   */
  onPageWillShow?: (fromContext: NavDestinationContext, toContext: NavDestinationContext) => void;

  /**
   * 页面跳转时回调
   * @param context
   */
  onNavigate?: (context: InterceptorInfo) => void;
  onShowCallback?: InterceptionShowCallback
}

export type ProcessCallback = (context: InterceptorInfo) => InterceptorInfoOrNull;

