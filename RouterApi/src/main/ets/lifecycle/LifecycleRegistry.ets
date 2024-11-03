import { RouterMgr } from "../api/RouterMgr";
import { ILifecycleObserver } from "./ILifecycleObserver";
import { LifecycleCallback } from "./LifecycleEventMgr";

/**
 * @author: HZWei
 * @date: 2024/10/26
 * @desc:
 */
export class LifecycleRegistry{
  constructor() {
  }

  public static create(): LifecycleRegistry {
    return new LifecycleRegistry();
  }


  public addObserver<T extends ILifecycleObserver>( observer: T) {
    RouterMgr.getInstance().lifecycleEventMgr.addObserver(observer);
  }

  public removeObserver(observer: ILifecycleObserver) {
    RouterMgr.getInstance().lifecycleEventMgr.removeObserver(observer);
  }

  public addListener(callback: LifecycleCallback) {
    RouterMgr.getInstance().lifecycleEventMgr.addListener(callback);
  }

  public removeListener(callback: LifecycleCallback) {
    RouterMgr.getInstance().lifecycleEventMgr.removeListener(callback);
  }


}

