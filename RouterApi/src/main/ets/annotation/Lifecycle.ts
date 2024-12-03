/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:
 */

import { LifecycleEvent } from "../lifecycle/LifecycleEvent";
import { LifecycleMgr } from "../lifecycle/LifecycleMgr";

export function Lifecycle(target: any, propertyKey: string) {

  hooks(target,
    propertyKey,
    LifecycleEvent.ABOUT_TO_DISAPPEAR, LifecycleEvent.ABOUT_TO_APPEAR,
    LifecycleEvent.ON_PAGE_SHOW, LifecycleEvent.ON_PAGE_HIDE)
}

function hooks(target: any, propertyKey: string, ...events: LifecycleEvent[]) {
  const className = `${target.constructor.name}`
  for (const event of events) {
    hook(target, className, event)
  }
}

export function hook(target: any, className: string, event: LifecycleEvent) {
  let lifecycleFun = target[event]
  if (!lifecycleFun){
    Reflect.defineProperty(target, event, {
      set: (newValue) => {
        lifecycleFun = newValue
      },
      get: () => lifecycleFun,
      enumerable: true,
      configurable: true
    })
    Reflect.defineProperty(target, event, {
      value: () => {
        try {
          lifecycleFun?.call(target)
          LifecycleMgr.getInstance().notifyObservers(event, undefined, className)
        } catch (e) {
          console.error(e)
        }
      },
      writable:true,
      enumerable: true,
      configurable: true
    });
  }else {
    function newFun() {
      lifecycleFun.call(this)
      LifecycleMgr.getInstance().notifyObservers(event, undefined, className)
    }
    target[event] = newFun
  }



}