/**
 * @author: HZWei
 * @date: 2024/10/27
 * @desc:
 */
import { RouterInfo } from "../model/RouterInfo";
import Logger from "../utlis/Logger";
import { ILifecycleObserver } from "./ILifecycleObserver";
import { LifecycleEvent } from "./LifecycleEvent";
import { ObserverState, SPLIT_SYMBOL } from "./ObserverState";

export class LifecycleMgr {
  private static _instance: LifecycleMgr;
  private _observerMap: Map<ILifecycleObserver, ObserverState> = new Map();
  private _listenerMap: Map<LifecycleCallback, ObserverState> = new Map();
  private removableObservers: ILifecycleObserver[] | undefined
  private removableListeners: LifecycleCallback[] | undefined


  private constructor() {
  }

  public static getInstance(): LifecycleMgr {
    if (!LifecycleMgr._instance) {
      LifecycleMgr._instance = new LifecycleMgr();
    }
    return LifecycleMgr._instance;
  }

  public addObserver(observer: ILifecycleObserver, targetClassName: string) {
    if (this._observerMap.has(observer)) {
      return;
    }
    Logger.log("ILifecycleObserver _observerMap 添加前: ", this._observerMap.size)
    const state = new ObserverState()
    state.className = targetClassName
    this._observerMap.set(observer, state);
    Logger.log("ILifecycleObserver _observerMap 添加后: ", this._observerMap.size)
  }


  public removeObserver(observer: ILifecycleObserver) {
    if (!this._observerMap.has(observer)) {
      return false
    }
    return this._observerMap.delete(observer);
  }

  public addListener(callback: LifecycleCallback, targetClassName: string) {
    if (this._listenerMap.has(callback)) {
      return;
    }
    Logger.log("ILifecycleObserver _listenerMap 添加前: ", this._listenerMap.size)
    const state = new ObserverState()
    state.className = targetClassName
    this._listenerMap.set(callback, state);
    Logger.log("ILifecycleObserver _listenerMap 添加后: ", this._listenerMap.size)
  }

  public removeListener(callback: LifecycleCallback) {
    if (!this._listenerMap.has(callback)) {
      return false
    }
    return this._listenerMap.delete(callback);
  }


  /**
   * 回收释放资源
   * @param className
   * @param observer
   * @param callback
   */
  private remove(className: string, observers?: ILifecycleObserver[], callbacks?: LifecycleCallback[]) {
    if (observers) {
      observers.forEach((observer) => {
        let success = this.removeObserver(observer)
        Logger.log(className, 'observer: ', success)
      })
      this.removableObservers = undefined
    }
    if (callbacks) {
      callbacks.forEach((callback) => {
        let success = this.removeListener(callback)
        Logger.log(className, 'callback: ', success)
      })
      this.removableObservers = undefined
    }


  }


  public getTopClassName(): string {
    let lastKV = Array.from(this._observerMap.entries()).pop()
    return lastKV && lastKV[1].className
  }

  private splitClassNameGetName(className: string): string {
    if (className.includes(SPLIT_SYMBOL)) {
      return className.split(SPLIT_SYMBOL)[0]
    }
    return className
  }

  private isCurrentPage(state: ObserverState, eventClassName?: string) {
    return eventClassName && state.className?.includes(eventClassName) &&
      this.splitClassNameGetName(state.className) == eventClassName
  }

  private isCurrentNavDestination(state: ObserverState, routerInfo?: RouterInfo) {
    return state.navDestinationId == routerInfo?.navDestinationId
  }

  public notifyObservers(event: LifecycleEvent, routerInfo?: RouterInfo, className?: string) {
    this.handleCallbackEvent(event, routerInfo, className)
    this.handleObserverEvent(event, routerInfo, className)
  }

  public findObservers(condition?: (key: ILifecycleObserver,
    value: ObserverState) => boolean): ILifecycleObserver[] {
    const keys: ILifecycleObserver[] = [];
    for (const [key, value] of this._observerMap.entries()) {
      if (condition(key, value)) {
        keys.push(key)
      }
    }
    return keys;
  }

  public findListeners(condition?: (key: LifecycleCallback,
    value: ObserverState) => boolean): LifecycleCallback[] {
    const keys: LifecycleCallback[] = [];
    for (const [key, value] of this._listenerMap.entries()) {
      if (condition(key, value)) {
        keys.push(key)
      }
    }
    return keys;
  }

  private handleObserverEvent(event: LifecycleEvent, routerInfo?: RouterInfo, className?: string) {
    const observerMap = Array.from(this._observerMap.entries()).reverse()
    for (const [observer, state] of observerMap) {
      const isCurrentPage = this.isCurrentPage(state, className)
      const isCurrentNavDestination = this.isCurrentNavDestination(state, routerInfo)
      switch (event) {
        case LifecycleEvent.ON_SHOWN:
          if (isCurrentNavDestination) {
            this.findObservers((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(observer => observer.onShown?.(routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_HIDDEN:
          if (isCurrentNavDestination) {
            this.findObservers((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(observer => observer.onHidden?.(routerInfo))
            return
          }
          break;

        case LifecycleEvent.ON_WILL_SHOW:
          if (isCurrentNavDestination) {
            this.findObservers((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(observer => observer.onWillShow?.(routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_WILL_HIDE:
          if (isCurrentNavDestination) {
            this.findObservers((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(observer => observer.onWillHide?.(routerInfo))
            return
          }
          break;

        case LifecycleEvent.ON_WILL_APPEAR:
          if (this.isEmpty(state.navDestinationId)) {
            this.findObservers((key, value) => {
              const isEmpty = this.isEmpty(value.navDestinationId)
              if (isEmpty) {
                value.navDestinationId = routerInfo?.navDestinationId
              }
              return isEmpty
            }).forEach(observer => observer.onWillAppear?.(routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_WILL_DISAPPEAR:
          if (isCurrentNavDestination) {
            this.findObservers((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(observer => observer.onWillDisappear?.(routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_APPEAR:
          if (isCurrentNavDestination) {
            this.findObservers((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(observer => observer.onAppear?.(routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_DISAPPEAR:
          if (isCurrentNavDestination) {
            const obs = this.findObservers((key, value) => {
             const isCurr = this.isCurrentNavDestination(value, routerInfo)
              if (isCurr) {
                value.isAboutToDisappearAllowed = true
              }
              return isCurr
            })
            this.removableObservers = obs
            obs.forEach(observer => observer.onDisappear?.(routerInfo))
            return
          }
          break;
        case LifecycleEvent.ABOUT_TO_APPEAR:
          if (isCurrentPage) {
            this.findObservers((key, value) => {
              const isCurr = this.isCurrentPage(value, className)
              const isAboutToAppearCalled = value.isAboutToAppearCalled
              if (isCurr && !isAboutToAppearCalled) {
                value.isAboutToAppearCalled = true
              }
              return isCurr && !isAboutToAppearCalled
            })
              .forEach(observer => observer.aboutToAppear?.())
            return
          }
          break;
        case LifecycleEvent.ON_PAGE_SHOW:
          if (isCurrentPage) {
            this.findObservers((key, value) => this.isCurrentPage(value, className))
              .forEach(observer => observer.onPageShow?.())
            return
          }
          break;
        case LifecycleEvent.ON_PAGE_HIDE:
          if (isCurrentPage) {
            this.findObservers((key, value) => this.isCurrentPage(value, className))
              .forEach(observer => observer.onPageHide?.())
            return
          }
          break;
        case LifecycleEvent.ABOUT_TO_DISAPPEAR:
          if (isCurrentPage) {
            this.findObservers((key, value) => this.isCurrentPage(value, className) && value.isAboutToDisappearAllowed)
              .forEach(observer => observer.aboutToDisappear?.())
            Logger.log('ILifecycleObserver remove observer:  ', this.removableObservers?.length ?? -1)
            this.remove(className, this.removableObservers ?? [observer], undefined)
            return
          }

          break;
      }

    }
  }


  private handleCallbackEvent(event: LifecycleEvent, routerInfo?: RouterInfo, className?: string) {
    const listenerMap = Array.from(this._listenerMap.entries()).reverse()
    for (const [callback, state] of listenerMap) {
      const isCurrentPage = this.isCurrentPage(state, className)
      const isCurrentNavDestination = this.isCurrentNavDestination(state, routerInfo)
      switch (event) {
        case LifecycleEvent.ON_SHOWN:
          if (isCurrentNavDestination) {
            this.findListeners((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(callback => callback(event, routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_HIDDEN:
          if (isCurrentNavDestination) {
            this.findListeners((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(callback => callback(event, routerInfo))
            return
          }
          break;

        case LifecycleEvent.ON_WILL_SHOW:
          if (isCurrentNavDestination) {
            this.findListeners((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(callback => callback(event, routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_WILL_HIDE:
          if (isCurrentNavDestination) {
            this.findListeners((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(callback => callback(event, routerInfo))
            return
          }
          break;

        case LifecycleEvent.ON_WILL_APPEAR:
          if (this.isEmpty(state.navDestinationId)) {
            this.findListeners((key, value) => {
              const isEmpty = this.isEmpty(value.navDestinationId)
              if (isEmpty) {
                value.navDestinationId = routerInfo?.navDestinationId
              }
              return isEmpty
            }).forEach(callback => callback(event, routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_WILL_DISAPPEAR:
          if (isCurrentNavDestination) {
            this.findListeners((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(callback => callback(event, routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_APPEAR:
          if (isCurrentNavDestination) {
            this.findListeners((key, value) => this.isCurrentNavDestination(value, routerInfo))
              .forEach(callback => callback(event, routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_DISAPPEAR:
          if (isCurrentNavDestination) {
            const obs = this.findListeners((key, value) => {
              const isCurr = this.isCurrentNavDestination(value, routerInfo)
              if (isCurr) {
                value.isAboutToDisappearAllowed = true
              }
              return isCurr
            })
            this.removableListeners = obs
            obs.forEach(callback => callback(event, routerInfo))
            return
          }
          break;
        case LifecycleEvent.ABOUT_TO_APPEAR:
          if (isCurrentPage) {
            this.findListeners((key, value) => {
              const isCurr = this.isCurrentPage(value, className)
              const isAboutToAppearCalled = value.isAboutToAppearCalled
              if (isCurr && !isAboutToAppearCalled) {
                value.isAboutToAppearCalled = true
              }
              return isCurr && !isAboutToAppearCalled
            })
              .forEach(callback => callback(event, routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_PAGE_SHOW:
          if (isCurrentPage) {
            this.findListeners((key, value) => this.isCurrentPage(value, className))
              .forEach(callback => callback(event, routerInfo))
            return
          }
          break;
        case LifecycleEvent.ON_PAGE_HIDE:
          if (isCurrentPage) {
            this.findListeners((key, value) => this.isCurrentPage(value, className))
              .forEach(callback => callback(event, routerInfo))
            return
          }
          break;
        case LifecycleEvent.ABOUT_TO_DISAPPEAR:
          if (isCurrentPage) {
            this.findListeners((key, value) => this.isCurrentPage(value, className) && value.isAboutToDisappearAllowed)
              .forEach(callback => callback(event, routerInfo))
            Logger.log('ILifecycleObserver remove callback:  ', this.removableListeners?.length ?? -1)
            this.remove(className, undefined, this.removableListeners ?? [callback])
            return
          }

          break;
      }
    }
  }


  private isEmpty(str: string) {
    return str === undefined || str === null || str.length === 0
  }
}

export type LifecycleCallback = (event: LifecycleEvent, router?: RouterInfo) => void;

