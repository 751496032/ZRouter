
/**
 * @author: HZWei
 * @date: 2024/12/1
 * @desc:
 */
import { LifecycleObserver } from "./LifecycleEvent"

export interface ILifecycleRegistry {
    addNavObserver(callback: LifecycleObserver)
    getLifecycle():ILifecycleRegistry
}