/**
 * @author: HZWei
 * @date: 2024/10/27
 * @desc:
 */
import { RouterInfo } from "../model/RouterInfo";
import { ILifecycleObserver } from "./ILifecycleObserver";
import { LifecycleEvent } from "./LifecycleEvent";
import { ObserverState } from "./ObserverState";

export class LifecycleEventMgr {

    private static _instance: LifecycleEventMgr;
    private _observerMap: Map<ILifecycleObserver, ObserverState> = new Map();
    private _listenerMap: Map<LifecycleCallback, ObserverState> = new Map();
    private _targets = new Array<string>()

    private constructor() {
    }

    public static getInstance(): LifecycleEventMgr {
        if (!LifecycleEventMgr._instance) {
          LifecycleEventMgr._instance = new LifecycleEventMgr();
        }
        return LifecycleEventMgr._instance;
    }

    public addObserver(observer: ILifecycleObserver) {
        if (this._observerMap.has(observer)) {
            return;
        }
        this._observerMap.set(observer, new ObserverState());
    }


    public removeObserver(observer: ILifecycleObserver) {
        if (!this._observerMap.has(observer)) {
            return;
        }
        this._observerMap.delete(observer);
    }

    public addListener(callback:LifecycleCallback) {
        if (this._listenerMap.has(callback)) {
            return;
        }
        this._listenerMap.set(callback, new ObserverState());
    }

    public removeListener(callback:LifecycleCallback) {
        if (!this._listenerMap.has(callback)) {
            return;
        }
        this._listenerMap.delete(callback);
    }

    public addAllTarget(targets: string[]) {
        targets.forEach((target) => {
            this.addTarget(target);
        })
    }


    private addTarget(target: string) {
        if (this._targets.includes(target)) {
            return;
        }
        this._targets.push(target);
    }

    private remove(observer?: ILifecycleObserver, callback?: LifecycleCallback, routerInfo?: RouterInfo) {

        if (routerInfo) {
            let index = this._targets.indexOf(routerInfo.name)
            if (index !== -1) {
                if (observer) {
                    this.removeObserver(observer)
                }
                if (callback) {
                    this.removeListener(callback)
                }
                this._targets.splice(index, 1)

            }
        }
    }


    public dispatchEvent(event: LifecycleEvent, routerInfo?: RouterInfo) {
        this._listenerMap.forEach((value, callback: LifecycleCallback) => {
            callback(event);
            if (event === LifecycleEvent.ON_DISAPPEAR || event === LifecycleEvent.ABOUT_TO_DISAPPEAR) {
                this.remove(undefined, callback,routerInfo)
            }
        })
        this._observerMap.forEach((value, observer: ILifecycleObserver) => {
            if (this._targets.length > 0 && !this._targets.includes(observer.routerName)) {
                return;
            }
            switch (event){
                case LifecycleEvent.ON_SHOWN:
                    observer.onShown?.(routerInfo);
                    break;
                case LifecycleEvent.ON_HIDDEN:
                    observer.onHidden?.(routerInfo);
                    break;
                case LifecycleEvent.ON_APPEAR:
                    observer.onAppear?.(routerInfo);
                    break;
                case LifecycleEvent.ON_DISAPPEAR:
                    observer.onDisappear?.(routerInfo);
                    this.remove(observer, undefined, routerInfo)
                    break;
                case LifecycleEvent.ON_WILL_SHOW:
                    observer.onWillShow?.(routerInfo);
                    break;
                case LifecycleEvent.ON_WILL_HIDE:
                    observer.onWillHide?.(routerInfo);
                    break;
                case LifecycleEvent.ON_WILL_APPEAR:
                    observer.onWillAppear?.(routerInfo);
                    break;
                case LifecycleEvent.ON_WILL_DISAPPEAR:
                    observer.onWillDisappear?.(routerInfo);
                    break;
                // case LifecycleEvent.ON_BACKPRESS:
                //     observer.onBackPress?.();
                //     break;
                case LifecycleEvent.ABOUT_TO_APPEAR:
                    observer.aboutToAppear?.();
                    break;
                case LifecycleEvent.ON_PAGE_SHOW:
                    observer.onPageShow?.();
                    break;
                case LifecycleEvent.ON_PAGE_HIDE:
                    observer.onPageHide?.();
                    break;
                case LifecycleEvent.ABOUT_TO_DISAPPEAR:
                    observer.aboutToDisappear?.();
                    this.remove(observer, undefined, routerInfo)
                    break;
            }

        })
    }

}
type LifecycleCallback = (event: LifecycleEvent) => void;

