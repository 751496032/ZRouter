import { RouterMgr } from "../api/RouterMgr";
import { ILifecycleObserver } from "./ILifecycleObserver";
import { LifecycleEvent } from "./LifecycleEvent";

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


  public addObserver<T extends ILifecycleObserver>(observer: T) {
    RouterMgr.getInstance().lifecycleEventMgr.addObserver(observer);
  }

  public removeObserver(observer: ILifecycleObserver) {
    RouterMgr.getInstance().lifecycleEventMgr.removeObserver(observer);
  }

  public addListener(callback: (event: LifecycleEvent) => void) {
    RouterMgr.getInstance().lifecycleEventMgr.addListener(callback);
  }

  public removeListener(callback: (event: LifecycleEvent) => void) {
    RouterMgr.getInstance().lifecycleEventMgr.removeListener(callback);
  }


}

// interface ILifecycleRegistry {
//   addObserver(observer: ILifecycleObserver): void;
//
//   addObserver(callback: (event: LifecycleEvent) => void): void;
// }