/**
 * @author: HZWei
 * @date: 2024/9/15
 * @desc:
 */
import { InterceptorInfo, InterceptorInfoOrNull } from '../model/Model';

export interface IInterceptor {
  process: ProcessCallback;
  priority: number;
}

export interface IPageNavigateInterceptor {
  onRootWillShow?: (fromContext: NavDestinationContext) => void;
  onPageWillShow?: (fromContext: NavDestinationContext, toContext: NavDestinationContext) => void;
  onNavigate?: (context: InterceptorInfo) => void;
  onShowCallback?: InterceptionShowCallback
}

export type ProcessCallback = (context: InterceptorInfo) => InterceptorInfoOrNull;

