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

    private isNavEvent(routerInfo?: RouterInfo) {
        if (!routerInfo) {
            return false;
        }
        return this._targets.length === 0 || this._targets.includes(routerInfo?.name ?? "")
    }


    public dispatchEvent(event: LifecycleEvent, routerInfo?: RouterInfo) {
        // this._listenerMap.forEach((value, callback: LifecycleCallback) => {
        //     callback(event);
        //     if (event === LifecycleEvent.ON_DISAPPEAR || event === LifecycleEvent.ABOUT_TO_DISAPPEAR) {
        //         this.remove(undefined, callback,routerInfo)
        //     }
        // })

        this._observerMap.forEach((value, observer: ILifecycleObserver) => {

            switch (event){
                case LifecycleEvent.ON_SHOWN:
                    if (this.isNavEvent(routerInfo)) {
                        observer.onShown?.(routerInfo);
                    }

                    break;
                case LifecycleEvent.ON_HIDDEN:
                    if (this.isNavEvent(routerInfo)) {
                        observer.onHidden?.(routerInfo);
                    }
                    break;
                case LifecycleEvent.ON_APPEAR:
                    if (this.isNavEvent(routerInfo)) {
                        observer.onAppear?.(routerInfo);
                    }
                    break;
                case LifecycleEvent.ON_DISAPPEAR:
                    if (this.isNavEvent(routerInfo)) {
                        observer.onDisappear?.(routerInfo);
                        this.remove(observer, undefined, routerInfo)
                    }
                    break;
                case LifecycleEvent.ON_WILL_SHOW:
                    if (this.isNavEvent(routerInfo)) {
                        observer.onWillShow?.(routerInfo);
                    }
                    break;
                case LifecycleEvent.ON_WILL_HIDE:
                    if (this.isNavEvent(routerInfo)) {
                        observer.onWillHide?.(routerInfo);
                    }
                    break;
                case LifecycleEvent.ON_WILL_APPEAR:
                    if (this.isNavEvent(routerInfo)) {
                        observer.onWillAppear?.(routerInfo);
                    }
                    break;
                case LifecycleEvent.ON_WILL_DISAPPEAR:
                    if (this.isNavEvent(routerInfo)) {
                        observer.onWillDisappear?.(routerInfo);
                    }
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

