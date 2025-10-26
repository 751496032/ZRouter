import {  INavLifecycle,  IPageLifecycle } from "./ILifecycle";

/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:  包括了router page和NavDestination的生命周期回调
 */
export interface ILifecycleObserver extends INavLifecycle, IPageLifecycle {
}


