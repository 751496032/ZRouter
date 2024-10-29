/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:
 */

import { LifecycleEvent } from "../lifecycle/LifecycleEvent";
import { LifecycleEventMgr } from "../lifecycle/LifecycleEventMgr";

export function Lifecycle(...routerName: string[]): PropertyDecorator {
  return (target: any, propertyKey: string) => {
    hooks(target,
      propertyKey,
      routerName,
      LifecycleEvent.ABOUT_TO_DISAPPEAR, LifecycleEvent.ABOUT_TO_APPEAR,
      LifecycleEvent.ON_PAGE_SHOW, LifecycleEvent.ON_PAGE_HIDE)
  }
}

function hooks(target: any, propertyKey: string, routerNames: string[], ...events: LifecycleEvent[]) {
  let propertyInstance = target[propertyKey]
  // 给LifecycleRegistry属性赋值
  Reflect.defineProperty(target, propertyKey, {
    set: (newValue) => propertyInstance = newValue,
    get: () => propertyInstance,
    enumerable: true,
    configurable: true
  })
  for (const event of events) {
    hook(target, routerNames,event)
  }
}

function hook(target: any,routerNames: string[], event: LifecycleEvent) {
  // 给页面的生命周期函数赋值
  let lifecycleFun = target[event]
  Reflect.defineProperty(target, event, {
    set: (newValue) => lifecycleFun = newValue,
    get: () => lifecycleFun,
    enumerable: true,
    configurable: true
  })

  Reflect.defineProperty(target, event, {
    value: () => {
      try {
        lifecycleFun?.call(target)
        LifecycleEventMgr.getInstance().addAllTarget(routerNames)
        LifecycleEventMgr.getInstance().dispatchEvent(event)
      } catch (e) {
        console.error(e)
      }
    },
    enumerable: true,
    configurable: true
  });
}