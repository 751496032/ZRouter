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

  private constructor(className: string) {
    this.targetClassName = className;
  }

  public static create(component: object): LifecycleRegistry {
    const className = `${component.constructor.name}${SPLIT_SYMBOL}${util.getHash(component)}`
    return new LifecycleRegistry(className);
  }


  public addObserver<T extends ILifecycleObserver>(observer: T) {
    RouterMgr.getInstance().lifecycleMgr.addObserver(observer, this.targetClassName, this.inRootView());

  }

  public removeObserver(observer: ILifecycleObserver): boolean {
    const isSuccess = RouterMgr.getInstance().lifecycleMgr.removeObserver(observer);
    return isSuccess
  }


  public addListener(callback: LifecycleCallback) {
    RouterMgr.getInstance().lifecycleMgr.addListener(callback, this.targetClassName, this.inRootView());
  }

  public removeListener(callback: LifecycleCallback): boolean {
    return RouterMgr.getInstance().lifecycleMgr.removeListener(callback);
  }

  private inRootView() {
    const lastId = RouterMgr.getInstance().getLastNavDestinationId()
    const hasPageBeenLaunched = RouterMgr.getInstance().hasPageBeenLaunched
    return lastId === undefined && !hasPageBeenLaunched
  }
}

export type  LifecycleRegistryOrNull = LifecycleRegistry | undefined | null;

