import { ZRouter } from "../api/Router"
import { RouterInfo } from "../model/RouterInfo"
import { ILifecycleRegistry } from "../lifecycle/ILifecycleRegistry"
import { LifecycleEvent, LifecycleObserver, LifecycleState } from "../lifecycle/LifecycleEvent"

/**
 * @author: HZWei
 * @date: 2024/12/7
 * @desc:  NavDest模版管理类
 */

export class TemplateMgr {

  private _templateMap: Map<string, ILifecycleRegistry | undefined> = new Map()
  private _observers: Map<string, LifecycleObserver[]> = new Map()
  private static _instance: TemplateMgr;

  private constructor() {
  }

  public static getInstance(): TemplateMgr {
    if (!TemplateMgr._instance) {
      TemplateMgr._instance = new TemplateMgr();
    }
    return TemplateMgr._instance;
  }

  addObserver(callback: LifecycleObserver): TemplateMgr {
    const navDesId = ZRouter.getLastNavDestinationId()
    if (navDesId) {
      const callbacks = this._observers.get(navDesId) ?? []
      callbacks.push(callback)
      this._observers.set(navDesId, callbacks)
    }
    return this
  }

  removeObserver(navDesId: string | undefined = undefined) {
    if (!navDesId) {
      navDesId = ZRouter.getLastNavDestinationId()
    }
    if (navDesId && this._observers.has(navDesId)) {
      this._observers.delete(navDesId)
    }
  }

  register(navDesId: string | undefined): void {
    if (navDesId && !this._templateMap.has(navDesId)) {
      this._templateMap.set(navDesId, undefined)
    }

  }

  private findObserver(navDesId: string | undefined):  LifecycleObserver[] | undefined {
    if (navDesId) {
      return this._observers.get(navDesId)
    }
    return undefined
  }

  private notifyObservers(navDesId: string | undefined, state: LifecycleState,  router?: RouterInfo) {
    const targets = this.findObserver(navDesId) || [];
    for (let i = 0; i < targets.length; i++) {
      const callback = targets[i]
      if (state !== LifecycleState.ON_BACK_PRESS) {
        callback(state, router)
      } else {
        const r = callback(state,router)
        if (typeof r === 'boolean') {
          return r;
        }
      }
    }
    return void 0;

  }

  dispatch(navDesId: string | undefined, event: LifecycleEvent, router?: RouterInfo): void | boolean {
    switch (event) {
      case LifecycleEvent.ON_WILL_SHOW:
          this.notifyObservers(navDesId, LifecycleState.ON_WILL_SHOW, router)
        break;
      case LifecycleEvent.ON_SHOWN:
        this.notifyObservers(navDesId, LifecycleState.ON_SHOWN,router)
        break;
      case LifecycleEvent.ON_WILL_HIDE:
        this.notifyObservers(navDesId, LifecycleState.ON_WILL_HIDE,router)
        break;
      case LifecycleEvent.ON_HIDDEN:
        this.notifyObservers(navDesId, LifecycleState.ON_HIDDEN,router)
        break;
      case LifecycleEvent.ON_WILL_DISAPPEAR:
        this.notifyObservers(navDesId, LifecycleState.ON_WILL_DISAPPEAR,router)
        break;
      case LifecycleEvent.ON_DISAPPEAR:
        this.notifyObservers(navDesId, LifecycleState.ON_DISAPPEAR,router)
        this.removeObserver(navDesId)
        break;
      case LifecycleEvent.ON_BACK_PRESS:
        return this.notifyObservers(navDesId, LifecycleState.ON_BACK_PRESS,router)

    }
  }


}


