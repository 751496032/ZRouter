import { RouterMgr } from "../api/RouterMgr";
import { ILifecycleObserver } from "./ILifecycleObserver";
import { LifecycleCallback } from "./LifecycleMgr";
import { util } from "@kit.ArkTS";
import { SPLIT_SYMBOL } from "./ObserverState";
import { ObjectUtil } from "../utlis/ObjectUtil";
import Logger from "../utlis/Logger";

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

  /**
   * 添加生命周期观察者
   * @param observer
   * @param inRootView 当前页面是否是Navigation根视图中 可选参数
   */
  public addObserver<T extends ILifecycleObserver>(observer: T, inRootView: boolean = false) {
    RouterMgr.getInstance().lifecycleMgr.addObserver(observer, this.targetClassName, inRootView);

  }

  public removeObserver(observer: ILifecycleObserver): boolean {
    const isSuccess = RouterMgr.getInstance().lifecycleMgr.removeObserver(observer);
    return isSuccess
  }


  /**
   * 添加生命周期监听
   * @param callback
   * @param inRootView 当前页面是否是Navigation根视图中 可选参数
   */
  public addListener(callback: LifecycleCallback, inRootView: boolean = false) {
    RouterMgr.getInstance().lifecycleMgr.addListener(callback, this.targetClassName, inRootView);
  }

  public removeListener(callback: LifecycleCallback): boolean {
    return RouterMgr.getInstance().lifecycleMgr.removeListener(callback);
  }

  // private inRootView() {
  //   const lastId = RouterMgr.getInstance().getLastNavDestinationId()
  //   const hasPageBeenLaunched = RouterMgr.getInstance().hasPageBeenLaunched
  //   Logger.log(`lastId:${lastId} hasPageBeenLaunched:${hasPageBeenLaunched}`)
  //   return ObjUtil.isEmpty(lastId) && !hasPageBeenLaunched
  // }
}

export type  LifecycleRegistryOrNull = LifecycleRegistry | undefined | null;

