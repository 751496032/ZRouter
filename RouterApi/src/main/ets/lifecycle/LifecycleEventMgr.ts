/**
 * @author: HZWei
 * @date: 2024/10/27
 * @desc:
 */
import { ILifecycleObserver } from "./ILifecycleObserver";
import { LifecycleEvent } from "./LifecycleEvent";
import { ObserverState } from "./ObserverState";

export class LifecycleEventMgr {

    private static _instance: LifecycleEventMgr;
    private _observerMap: Map<ILifecycleObserver, ObserverState> = new Map();
    private _listenerMap: Map<(event: LifecycleEvent) => void, ObserverState> = new Map();
    private _observers = new Array<string>()

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

    public addListener(callback:(event: LifecycleEvent) => void) {
        if (this._listenerMap.has(callback)) {
            return;
        }
        this._listenerMap.set(callback, new ObserverState());
    }

    public removeListener(callback:(event: LifecycleEvent) => void) {
        if (!this._listenerMap.has(callback)) {
            return;
        }
        this._listenerMap.delete(callback);
    }



    public dispatchEvent(event: LifecycleEvent) {
        this._listenerMap.forEach((value, callback: (event: LifecycleEvent) => void) => {
            callback(event);
        })
        this._observerMap.forEach((value, observer: ILifecycleObserver) => {
            switch (event){
                case LifecycleEvent.ON_SHOWN:
                    observer.onShown?.();
                    break;
                case LifecycleEvent.ON_HIDDEN:
                    observer.onHidden?.();
                    break;
                case LifecycleEvent.ON_APPEAR:
                    observer.onAppear?.();
                    break;
                case LifecycleEvent.ON_DISAPPEAR:
                    observer.onDisappear?.();
                    break;
                case LifecycleEvent.ON_WILL_SHOW:
                    observer.onWillShow?.();
                    break;
                case LifecycleEvent.ON_WILL_HIDE:
                    observer.onWillHide?.();
                    break;
                case LifecycleEvent.ON_WILL_APPEAR:
                    observer.onWillAppear?.();
                    break;
                case LifecycleEvent.ON_WILL_DISAPPEAR:
                    observer.onWillDisappear?.();
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
                    break;
            }

        })
    }

}

