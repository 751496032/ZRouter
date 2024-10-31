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
    private _targetMap: Map<string, Array<string>> = new Map()
    private _currentRoute: RouterInfo | undefined

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
        console.log("ILifecycleObserver 添加前: ", this._observerMap.size)
        this._observerMap.set(observer, new ObserverState());
        console.log("ILifecycleObserver 添加后: ", this._observerMap.size)
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



    public setTarget(name: string, lifecycleNames: string[]) {
        if (this._targetMap.has(name)) {
            let list: string[] = this._targetMap.get(name) ?? []
            let targets = lifecycleNames.filter((item) => !list.includes(item))
            list.push(...targets)
        } else {
            this._targetMap.set(name, lifecycleNames)
        }
    }


    /**
     *
     * @param className
     * @param observer
     * @param callback
     */
    private remove(className: string, observer?: ILifecycleObserver, callback?: LifecycleCallback) {

        if (this._targetMap.has(className) && this._currentRoute) {
            let list: string[] = this._targetMap.get(className) ?? []
            let index = list.indexOf(this._currentRoute?.name)
            if (index !== -1) {
                list.splice(index, 1)
                if (observer) {
                    console.log("ILifecycleObserver 删除前: ", this._observerMap.size)
                  let success =   this._observerMap.delete(observer)
                    console.log("ILifecycleObserver 删除后：",className, this._currentRoute.name, success)
                    console.log("ILifecycleObserver 删除后: ", this._observerMap.size)
                }
                if (callback) {
                    this._listenerMap.delete(callback)
                }
            }
        }
    }

    private isNavEvent(routerInfo?: RouterInfo) {
        if (!routerInfo) {
            return false;
        }
        let isNav = false
        const values = this._targetMap.values()
        for (const value of values) {
            if (!isNav) {
                isNav = value.includes(routerInfo.name)
            } else {
                break
            }
        }
        return isNav
    }


    public dispatchEvent(event: LifecycleEvent, routerInfo?: RouterInfo, className?: string) {
        // this._listenerMap.forEach((value, callback: LifecycleCallback) => {
        //     callback(event);
        //     if (event === LifecycleEvent.ON_DISAPPEAR || event === LifecycleEvent.ABOUT_TO_DISAPPEAR) {
        //         this.remove(undefined, callback,routerInfo)
        //     }
        // })
        if (routerInfo){
            this._currentRoute = routerInfo
        }
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
                    this.remove(className, observer, undefined)
                    break;
            }

        })
    }

}
type LifecycleCallback = (event: LifecycleEvent) => void;

