/**
 * @author: HZWei
 * @date: 2024/9/15
 * @desc:
 */
import { InterceptorInfo, InterceptorInfoOrNull } from '../model/Model';

export interface IInterceptor {
  /**
   * 处理push和replace拦截器逻辑，返回null则表示拦截器处理完成，否则继续执行下一个拦截器
   * @param context
   * @returns
   */
  process: (context: InterceptorInfo) => InterceptorInfoOrNull;
  /**
   * 拦截器优先级，数值越大则优先执行
   */
  priority: number;
}

export interface IGlobalNavigateInterceptor {
  /**
   * Navigation根视图显示时回调
   * @param fromContext
   */
  onRootWillShow?: (fromContext: NavDestinationContext) => void;

  /**
   * 页面显示时回调，当fromContext、toContext是一样时，则在NavBar根页面中启动的
   * @param fromContext
   * @param toContext
   */
  onPageWillShow?: (fromContext: NavDestinationContext, toContext: NavDestinationContext) => void;

  /**
   * 页面push 或者 replace回调
   * @param context
   */
  onNavigate?: (context: InterceptorInfo) => void;
  onShowCallback?: InterceptionShowCallback
}

export type ProcessCallback = (context: InterceptorInfo) => InterceptorInfoOrNull;

