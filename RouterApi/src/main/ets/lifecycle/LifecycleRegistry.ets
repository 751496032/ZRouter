import { RouterMgr } from "../api/RouterMgr";
import { ILifecycleObserver } from "./ILifecycleObserver";
import { LifecycleCallback } from "./LifecycleMgr";
import { util } from "@kit.ArkTS";
import { SPLIT_SYMBOL } from "./ObserverState";

/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:
 */
export class LifecycleRegistry {
  private targetClassName: string
  private currentLifecycleObserver: ILifecycleObserver | null = null;

  private constructor(className: string) {
    this.targetClassName = className;
  }

  public static create(component: object): LifecycleRegistry {
    const className = `${component.constructor.name}${SPLIT_SYMBOL}${util.getHash(component)}`
    return new LifecycleRegistry(className);
  }


  public addObserver<T extends ILifecycleObserver>(observer: T) {
    RouterMgr.getInstance().lifecycleMgr.addObserver(observer, this.targetClassName);
    this.currentLifecycleObserver = observer;
  }

  public removeObserver(observer: ILifecycleObserver): boolean {
    const isSuccess = RouterMgr.getInstance().lifecycleMgr.removeObserver(observer);
    this.currentLifecycleObserver = null;
    return isSuccess
  }

  public getCurrentObserver<T extends ILifecycleObserver>(): T | null {
    try {
      return this.currentLifecycleObserver as T
    } catch (e) {
      return null
    }

  }

  public addListener(callback: LifecycleCallback) {
    RouterMgr.getInstance().lifecycleMgr.addListener(callback, this.targetClassName);
  }

  public removeListener(callback: LifecycleCallback): boolean {
    return RouterMgr.getInstance().lifecycleMgr.removeListener(callback);
  }
}

export type  LifecycleRegistryOrNull = LifecycleRegistry | undefined | null;

