/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:
 */

import { LifecycleEvent } from "../lifecycle/LifecycleEvent";
import { LifecycleEventMgr } from "../lifecycle/LifecycleEventMgr";
import 'reflect-metadata';
import { util } from "@kit.ArkTS";

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
    set: (newValue) => {
      propertyInstance = newValue
      try {
        util.getHash(target)
        console.log("")
        const key = target.constructor.name + "_" + propertyKey
        if (!Reflect.hasMetadata(key, target,propertyKey)) {
          Reflect.defineMetadata(key, routerNames, target,propertyKey)
          console.log("set hooks: ", routerNames," key: "+key)
          target.routerNames = routerNames
          LifecycleEventMgr.getInstance().setTarget(target.constructor.name, routerNames)
        }else {
          let p = Reflect.getMetadata(key, target,propertyKey)
          console.log("set hooks: ", `p：${p}`, Reflect.hasMetadata(key, target), " key: " + key)
          console.log("set hooks: " ,target.routerNames)
        }

      }catch (e) {
        console.error("hooks err: ",e)
      }

    },
    get: () => {
      return propertyInstance
    },
    enumerable: true,
    configurable: true
  })
  for (const event of events) {
    hook(target, routerNames, event)
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
        if (event === LifecycleEvent.ABOUT_TO_DISAPPEAR) {
          console.log("class name: ", target.constructor.name, "  event name: ", event)
        }
        lifecycleFun?.call(target)
        LifecycleEventMgr.getInstance().dispatchEvent(event, undefined, target.constructor.name)
      } catch (e) {
        console.error(e)
      }
    },
    enumerable: true,
    configurable: true
  });
}