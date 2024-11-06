/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:
 */

import { LifecycleEvent } from "../lifecycle/LifecycleEvent";
import { LifecycleEventMgr } from "../lifecycle/LifecycleEventMgr";

export function Lifecycle(target: any, propertyKey: string) {
  // if (!target['build']) {
  //   throw new Error('@Lifecycle only for UI components')
  // }

  // Reflect.defineProperty(target, `${propertyKey}_router`, {
  //   value: router,
  //   writable: false,
  //   enumerable: false,
  //   configurable: false
  // });
  hooks(target,
    propertyKey,
    LifecycleEvent.ABOUT_TO_DISAPPEAR, LifecycleEvent.ABOUT_TO_APPEAR,
    LifecycleEvent.ON_PAGE_SHOW, LifecycleEvent.ON_PAGE_HIDE)
}

function hooks(target: any, propertyKey: string, ...events: LifecycleEvent[]) {
  const className = `${target.constructor.name}`
  // console.log("hook className: " , className ,this)
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
          LifecycleEventMgr.getInstance().dispatchEvent(event, undefined, className)
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
      LifecycleEventMgr.getInstance().dispatchEvent(event, undefined, className)
    }
    target[event] = newFun
  }



}