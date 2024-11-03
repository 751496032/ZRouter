/**
 * @author: HZWei
 * @date: 2024/10/27
 * @desc:
 */
import { RouterInfo } from "../model/RouterInfo";
import { ILifecycleObserver } from "./ILifecycleObserver";
import { LifecycleEvent } from "./LifecycleEvent";
import { ObserverState } from "./ObserverState";
import { util } from "@kit.ArkTS";

export class LifecycleEventMgr {

    private static _instance: LifecycleEventMgr;
    private _observerMap: Map<ILifecycleObserver, ObserverState> = new Map();
    private _listenerMap: Map<LifecycleCallback, ObserverState> = new Map();
    private _targetMap: Map<string, Array<string>> = new Map()
    private _currentRoute: RouterInfo | undefined
    private _currentObject: object

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



    /**
     * todo： 待解决的问题，如果打开一个类的组件，生命周期会重复监听
     * @param className
     * @param lifecycleNames
     */
    public setTarget(className: string, lifecycleNames: string[]) {
        if (this._targetMap.has(className)) {
            let list: string[] = this._targetMap.get(className) ?? []
            let targets = lifecycleNames.filter((item) => !list.includes(item))
            list.push(...targets)
        } else {
            this._targetMap.set(className, lifecycleNames)
        }
    }


    /**
     * 回收释放资源
     * @param className
     * @param observer
     * @param callback
     */
    private remove(className: string, observer?: ILifecycleObserver, callback?: LifecycleCallback) {
        if (this._targetMap.has(className)) {
            let list: string[] = this._targetMap.get(className) ?? []
            if (this._currentRoute) {
                let index = list.indexOf(this._currentRoute?.name)
                if (index !== -1) {
                    list.splice(index, 1)
                }
            }
            if (observer) {
                let success = this._observerMap.delete(observer)
                console.log(className, 'observer: ', success)
            }
            if (callback) {
                let success = this._listenerMap.delete(callback)
                console.log(className, 'callback: ', success)
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
        if (this.isNavEvent(routerInfo)){
            this._currentRoute = routerInfo
        }
        this._listenerMap.forEach((value, callback: LifecycleCallback) => {
            callback(event);
            if (event === LifecycleEvent.ABOUT_TO_DISAPPEAR) {
                this.remove(className, undefined, callback)
            }
        })

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

export type LifecycleCallback = (event: LifecycleEvent, router?: RouterInfo) => void;

