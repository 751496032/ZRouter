/**
 * @author: HZWei
 * @date: 2024/9/15
 * @desc:
 */
import { DestinationInfo, InterceptorInfo, InterceptorInfoOrNull } from '../model/Model';

export interface IInterceptor {
  /**
   * 处理push和replace拦截器逻辑，返回null或undefined则表示拦截器处理完成，否则继续执行下一个拦截器
   * @param context
   * @returns
   */
  process: (context: InterceptorInfo) => InterceptorInfoOrNull;
  /**
   * 拦截器优先级，数值越大则优先执行
   */
  priority: number;
}
/**
 * 全局拦截器
 * 执行顺序： onNavigateBefore  -> [IInterceptor#process] -> onNavigate  -> onPageWillShow [onShowCallback]
 */
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
   * 页面push 或者 replace跳转时回调
   * @param context
   */
  onNavigate?: (context: InterceptorInfo) => void;
  onShowCallback?: InterceptionShowCallback
  /**
   * 在跳转之前回调，可以在此回调中拦截跳转做一些自定义的逻辑，比如修改路由参数、数据预取、拦截跳转、拦截登录等场景
   * @param dest
   * @returns  DestinationInfo#action 为NavigationAction.BLOCK 则表示拦截跳转，NEXT继续执行
   * @note
   * 如果通过ZRouter.getNavStack().push()方法跳转，则不会回调此方法,
   * 只有通过ZRouter.getInstance().push()方法跳转时会回调此方法
   */

  onNavigateBefore?: (dest: DestinationInfo) => Promise<DestinationInfo>;
}

export type ProcessCallback = (context: InterceptorInfo) => InterceptorInfoOrNull;

