/**
 * @author: HZWei
 * @date: 2024/9/15
 * @desc:
 */

export interface IInterceptor {

}

export class ShowInterceptor implements IInterceptor {
    onRootWillShow?: (fromContext: NavDestinationContext) => void;
    onPageWillShow?: (fromContext: NavDestinationContext, toContext: NavDestinationContext) => void;
    onShowCallback?: InterceptionShowCallback
}

export enum InterceptorTypes{
    PAGE_SHOW
}