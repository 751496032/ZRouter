/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:
 */

import { LifecycleEvent } from "../lifecycle/LifecycleEvent";
import { LifecycleEventMgr } from "../lifecycle/LifecycleEventMgr";
import { util } from "@kit.ArkTS";

export function Lifecycle(...router: string[]): PropertyDecorator {
  if (!router || router.length <= 0) {
    throw new Error('Add monitored route names in @Lifecycle')
  }
  return (target: any, propertyKey: string) => {
    Reflect.defineProperty(target, `${propertyKey}_router`, {
      value: router,
      writable: false,
      enumerable: false,
      configurable: false
    });
    hooks(target,
      propertyKey,
      LifecycleEvent.ABOUT_TO_DISAPPEAR, LifecycleEvent.ABOUT_TO_APPEAR,
      LifecycleEvent.ON_PAGE_SHOW, LifecycleEvent.ON_PAGE_HIDE)
  }
}

function hooks(target: any, propertyKey: string, ...events: LifecycleEvent[]) {
  const className = `${target.constructor.name}_${util.getHash(target)}`
  console.log("hook className: " , className ,this)
  LifecycleEventMgr.getInstance().setTarget(className, target[`${propertyKey}_router`])
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