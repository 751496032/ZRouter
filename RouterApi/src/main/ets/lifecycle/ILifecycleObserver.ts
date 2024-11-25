import { INavActiveLifecycle, INavLifecycle,  IPageLifecycle } from "./ILifecycle";

/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:
 */
export interface ILifecycleObserver extends INavLifecycle, IPageLifecycle {
}

export interface IActiveLifecycleObserver extends INavActiveLifecycle {

}


