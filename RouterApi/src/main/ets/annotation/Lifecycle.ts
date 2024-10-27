/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:
 */

import { LifecycleEvent } from "../lifecycle/LifecycleEvent";
import { LifecycleEventMgr } from "../lifecycle/LifecycleEventMgr";

export function Lifecycle(routerName?: string): PropertyDecorator {
  return (target: any, propertyKey: string) => {
    hooks(target,
      propertyKey,
      routerName,
      LifecycleEvent.ABOUT_TO_DISAPPEAR, LifecycleEvent.ABOUT_TO_APPEAR,
      LifecycleEvent.ON_PAGE_SHOW, LifecycleEvent.ON_PAGE_HIDE)
  }
}

function hooks(target: any, propertyKey: string, routerName: string, ...events: LifecycleEvent[]) {
  let propertyInstance = target[propertyKey]
  // 给LifecycleRegistry属性赋值
  Reflect.defineProperty(target, propertyKey, {
    set: (newValue) => propertyInstance = newValue,
    get: () => propertyInstance,
    enumerable: true,
    configurable: true
  })
  for (const event of events) {
    hook(target, routerName,event)
  }
}

function hook(target: any,routerName: string, event: LifecycleEvent) {
  if (!target[event]) {
    // 给页面的生命周期函数赋值
    let propertyInstance = target[event]
    Reflect.defineProperty(target, event, {
      set: (newValue) => propertyInstance = newValue,
      get: () => propertyInstance,
      enumerable: true,
      configurable: true
    })
  }

  const lifecycleFun = target[event]
  Reflect.defineProperty(target, event, {
    value: () => {
      try {
        lifecycleFun.call(target)
      } catch (e) {
        console.error(e)
      }
      LifecycleEventMgr.getInstance().dispatchEvent(event)
    },
    enumerable: true,
    configurable: true
  });
}