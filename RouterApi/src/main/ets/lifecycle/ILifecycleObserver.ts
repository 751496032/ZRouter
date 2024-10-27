import { INavLifeCycle, IPageLifeCycle } from "./ILifecycle";

/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:
 */
export interface ILifecycleObserver extends INavLifeCycle, IPageLifeCycle {}
