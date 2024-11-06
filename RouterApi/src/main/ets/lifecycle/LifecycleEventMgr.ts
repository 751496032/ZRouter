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
    private _lifecycleObserver: ILifecycleObserver | undefined
    private _lifecycleCallback: LifecycleCallback | undefined

    private constructor() {
    }

    public static getInstance(): LifecycleEventMgr {
        if (!LifecycleEventMgr._instance) {
          LifecycleEventMgr._instance = new LifecycleEventMgr();
        }
        return LifecycleEventMgr._instance;
    }

    public addObserver(observer: ILifecycleObserver, targetClassName: string) {
        if (this._observerMap.has(observer)) {
            return;
        }
        console.log("ILifecycleObserver _observerMap 添加前: ", this._observerMap.size)
        const state = new ObserverState()
        state.className = targetClassName
        this._observerMap.set(observer, state);
        console.log("ILifecycleObserver _observerMap 添加后: ", this._observerMap.size)
    }


    public removeObserver(observer: ILifecycleObserver) {
        if (!this._observerMap.has(observer)) {
            return false
        }
       return this._observerMap.delete(observer);
    }

    public addListener(callback:LifecycleCallback,targetClassName: string) {
        if (this._listenerMap.has(callback)) {
            return;
        }
        console.log("ILifecycleObserver _listenerMap 添加前: ", this._listenerMap.size)
        const state = new ObserverState()
        state.className = targetClassName
        this._listenerMap.set(callback, state);
        console.log("ILifecycleObserver _listenerMap 添加后: ", this._listenerMap.size)
    }

    public removeListener(callback:LifecycleCallback) {
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
    private remove(className: string, observer?: ILifecycleObserver, callback?: LifecycleCallback) {
        if (observer) {
            let success = this.removeObserver(observer)
            console.log(className, 'observer: ', success)
            this._lifecycleObserver = undefined
        }
        if (callback) {
            let success = this.removeListener(callback)
            console.log(className, 'callback: ', success)
            this._lifecycleCallback = undefined
        }


    }



    public getTopClassName(): string {
        let lastKV = Array.from(this._observerMap.entries()).pop()
        return  lastKV && lastKV[1].className
    }

    public dispatchEvent(event: LifecycleEvent, routerInfo?: RouterInfo, className?: string) {
        this.handleCallbackEvent(event, routerInfo, className)
        this.handleObserverEvent(event, routerInfo, className)
    }

    private handleObserverEvent(event: LifecycleEvent, routerInfo?: RouterInfo, className?: string){
        const observerMap =  Array.from(this._observerMap.entries()).reverse()
        for (const [observer, value] of observerMap) {
            // console.log(`Key: ${observer}, Value: ${value}`);
            const isCurrentPage = className && value.className?.includes(className)
            const isCurrentNavDestination =  value.navDestinationId == routerInfo?.navDestinationId
            switch (event){
                case LifecycleEvent.ON_SHOWN:
                    if (isCurrentNavDestination) {
                        observer.onShown?.(routerInfo);
                        return
                    }
                    break;
                case LifecycleEvent.ON_HIDDEN:
                    if (isCurrentNavDestination) {
                        observer.onHidden?.(routerInfo);
                        return
                    }
                    break;

                case LifecycleEvent.ON_WILL_SHOW:
                    if (isCurrentNavDestination) {
                        observer.onWillShow?.(routerInfo);
                        return
                    }
                    break;
                case LifecycleEvent.ON_WILL_HIDE:
                    if (isCurrentNavDestination) {
                        observer.onWillHide?.(routerInfo);
                        return
                    }
                    break;

                case LifecycleEvent.ON_WILL_APPEAR:
                    if (this.isEmpty(value.navDestinationId)) {
                        value.navDestinationId = routerInfo?.navDestinationId
                        observer.onWillAppear?.(routerInfo);
                        return
                    }
                    break;
                case LifecycleEvent.ON_WILL_DISAPPEAR:
                    if (isCurrentNavDestination) {
                        observer.onWillDisappear?.(routerInfo);
                        return
                    }
                    break;
                case LifecycleEvent.ON_APPEAR:
                    if (isCurrentNavDestination) {
                        observer.onAppear?.(routerInfo);
                        return
                    }
                    break;
                case LifecycleEvent.ON_DISAPPEAR:
                    if (isCurrentNavDestination) {
                        observer.onDisappear?.(routerInfo);
                        this._lifecycleObserver = observer
                        return
                    }
                    break;
                case LifecycleEvent.ABOUT_TO_APPEAR:
                    if (isCurrentPage) {
                        observer.aboutToAppear?.();
                        return
                    }
                    break;
                case LifecycleEvent.ON_PAGE_SHOW:
                    if (isCurrentPage) {
                        observer.onPageShow?.();
                        return
                    }
                    break;
                case LifecycleEvent.ON_PAGE_HIDE:
                    if (isCurrentPage) {
                        observer.onPageHide?.();
                        return
                    }
                    break;
                case LifecycleEvent.ABOUT_TO_DISAPPEAR:
                    if (isCurrentPage) {
                        observer.aboutToDisappear?.();
                        console.log('ILifecycleObserver remove observer:  ', this._lifecycleObserver !== undefined)
                        this.remove(className, this._lifecycleObserver ?? observer, undefined)
                        return
                    }

                    break;
            }

        }
    }

    private handleCallbackEvent(event: LifecycleEvent, routerInfo?: RouterInfo, className?: string){
        const listenerMap =  Array.from(this._listenerMap.entries()).reverse()
        for (const [callback, value] of listenerMap) {
            const isCurrentPage = className && value.className?.includes(className)
            const isCurrentNavDestination =  value.navDestinationId == routerInfo?.navDestinationId
            switch (event){
                case LifecycleEvent.ON_SHOWN:
                    if (isCurrentNavDestination) {
                        callback(event, routerInfo)
                        return
                    }
                    break;
                case LifecycleEvent.ON_HIDDEN:
                    if (isCurrentNavDestination) {
                        callback(event, routerInfo)
                        return
                    }
                    break;

                case LifecycleEvent.ON_WILL_SHOW:
                    if (isCurrentNavDestination) {
                        callback(event, routerInfo)
                        return
                    }
                    break;
                case LifecycleEvent.ON_WILL_HIDE:
                    if (isCurrentNavDestination) {
                        callback(event, routerInfo)
                        return
                    }
                    break;

                case LifecycleEvent.ON_WILL_APPEAR:
                    if (this.isEmpty(value.navDestinationId)) {
                        value.navDestinationId = routerInfo?.navDestinationId
                        callback(event, routerInfo)
                        return
                    }
                    break;
                case LifecycleEvent.ON_WILL_DISAPPEAR:
                    if (isCurrentNavDestination) {
                        callback(event, routerInfo)
                        return
                    }
                    break;
                case LifecycleEvent.ON_APPEAR:
                    if (isCurrentNavDestination) {
                        callback(event, routerInfo)
                        return
                    }
                    break;
                case LifecycleEvent.ON_DISAPPEAR:
                    if (isCurrentNavDestination) {
                        callback(event, routerInfo)
                        this._lifecycleCallback = callback
                        return
                    }
                    break;
                case LifecycleEvent.ABOUT_TO_APPEAR:
                    if (isCurrentPage) {
                        callback(event, routerInfo)
                        return
                    }
                    break;
                case LifecycleEvent.ON_PAGE_SHOW:
                    if (isCurrentPage) {
                        callback(event, routerInfo)
                        return
                    }
                    break;
                case LifecycleEvent.ON_PAGE_HIDE:
                    if (isCurrentPage) {
                        callback(event, routerInfo)
                        return
                    }
                    break;
                case LifecycleEvent.ABOUT_TO_DISAPPEAR:
                    if (isCurrentPage) {
                        callback(event, routerInfo)
                        console.log('ILifecycleObserver remove callback:  ', this._lifecycleCallback !==undefined)
                        this.remove(className, undefined, this._lifecycleCallback ?? callback)
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

