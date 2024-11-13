/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjectUtil } from '../utlis/ObjectUtil'
import {
  DEFAULT_STACK_NAME,
  InterceptorInfo,
  NavRootEvent,
  ObjectOrNull,
  OnInterceptorCallback,
  OnPopCallback,
  OnPopResultCallback,
  PopResult,
  RouteMetadata
} from '../model/Model'
import LogUtil from '../utlis/LogUtil'
import { BusinessError, emitter } from '@kit.BasicServicesKit'
import uiObserver from '@ohos.arkui.observer';
import { InterceptorMgr } from '../interceptions/InterceptorMgr'
import { IInterceptor, IGlobalNavigateInterceptor } from '../interceptions/IInterceptor'
import NavStackMgr from './NavStackMgr'
import { NavBuilder } from '../model/NavBuilder'
import { ErrorCode } from '../model/Const'
import { ServiceMgr } from '../service/ServiceMgr';
import { LifecycleMgr } from '../lifecycle/LifecycleMgr';
import { RouterInfo } from '../model/RouterInfo';
import { LifecycleEvent } from '../lifecycle/LifecycleEvent';


export class RouterMgr {
  private interceptorMgr = InterceptorMgr.getInstance()
  private navStackMgr = NavStackMgr.getInstance()
  private serviceMgr = ServiceMgr.instance
  private _lifecycleMgr = LifecycleMgr.getInstance()

  private constructor() {
    uiObserver.on('navDestinationUpdate', (info) => {
      const name = info.name.toString()
      if (ObjectUtil.isEmpty(name)) {
        return
      }
      const routerInfo = RouterInfo.create(name, info.navigationId.toString(), info.param, info.navDestinationId)
      // const className = this._lifecycleEventMgr.getTopClassName()
      switch (info.state) {
        case uiObserver.NavDestinationState.ON_SHOWN:
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_SHOWN, routerInfo)
          break
        case uiObserver.NavDestinationState.ON_HIDDEN:
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_HIDDEN, routerInfo)
          break
        case uiObserver.NavDestinationState.ON_APPEAR:
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_APPEAR, routerInfo)
          break
        case uiObserver.NavDestinationState.ON_DISAPPEAR:
          const indexList = this.getNavStack().getIndexByName(name)
          if (indexList.length == 0) {
            this.unregisterEvent(name)
          }
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_DISAPPEAR, routerInfo)
          break
        case uiObserver.NavDestinationState.ON_WILL_SHOW:
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_WILL_SHOW, routerInfo)
          break
        case uiObserver.NavDestinationState.ON_WILL_HIDE:
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_WILL_HIDE, routerInfo)
          break
        case uiObserver.NavDestinationState.ON_WILL_APPEAR:
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_WILL_APPEAR, routerInfo)
          break
        case uiObserver.NavDestinationState.ON_WILL_DISAPPEAR:
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_WILL_DISAPPEAR, routerInfo)
          break
        case uiObserver.NavDestinationState.ON_BACKPRESS:
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_BACKPRESS, routerInfo)
          break

      }
    });
  }

  private static instance: RouterMgr

  public static getInstance(): RouterMgr {
    if (!RouterMgr.instance) {
      RouterMgr.instance = new RouterMgr()
      return RouterMgr.instance
    }
    return RouterMgr.instance
  }

  public getServiceMgr(): ServiceMgr {
    return this.serviceMgr
  }

  public get lifecycleMgr(): LifecycleMgr {
    return this._lifecycleMgr
  }

  public setCurrentStackName(name: string) {
    this.navStackMgr.currentStackName = name
  }

  public get currentStackName(): string {
    return this.navStackMgr.currentStackName
  }


  /**
   * 只能注册一次
   * @param stackName
   * @param pathStack
   * @param willShow
   */
  public registerNavStack(stackName: string = DEFAULT_STACK_NAME, pathStack: NavPathStack,
    willShow?: InterceptionShowCallback): void {
    this.navStackMgr.registerNavStack(stackName, pathStack, willShow)
  }

  public unregisterNavStack(stackName: string) {
    this.navStackMgr.unregisterNavStack(stackName)
  }

  public getNavStack(willShow?: InterceptionShowCallback): NavPathStack {
    return this.navStackMgr.getNavStack(this.navStackMgr.currentStackName, willShow)
  }


  public getNavStackByName(stackName: string, willShow?: InterceptionShowCallback): NavPathStack {
    return this.navStackMgr.getNavStackByName(stackName, willShow)
  }


  private getCurrentState() {
    return this.navStackMgr.getNavStackState()
  }

  /**
   * 页面跳转
   * @param name 是Route装饰器上的name属性值
   * @param param 携带的参数
   */
  public push<T>(name: string, param?: ObjectOrNull, animated: boolean = false, builder?: NavBuilder<T>) {
    this.pushDestination<T>(name, param, undefined, builder)
  }

  /**
   * 页面跳转 可监听返回结果，需与popWithResult配合使用
   * pushForResult - popWithResult
   * 场景 A->B， B->A ，A监听B的返回结果
   * @see {popWithResult}
   * @param name
   * @param param
   * @param callback
   */
  public pushForResult<T>(name: string, param?: ObjectOrNull, callback?: OnPopCallback,
    builder?: NavBuilder<T>) {
    this.pushDestination<T>(name, param, callback, builder)
  }

  /**
   * 监听返回结果跳转，必须与popNavWithResult配合使用
   * 当跳转多个页面，并且返回需要携带结果时使用
   * 比如 A->B->C->D 当页面在D时，需要返回到A并携带结果，此时在A就可以监听D的返回结果
   * pushNavForResult - popNavWithResult
   * pushNavForResult - popToRootWithResult
   * @see {popNavWithResult}
   * @param name
   * @param param
   * @param callback
   */
  public pushNavForResult<T>(name: string, param?: ObjectOrNull, callback?: OnPopResultCallback<T>,
    builder?: NavBuilder<T>) {
    const topName = this.getTopPathName()
    this.pushDestination(name, param, undefined, builder).then(() => {
      let eName = ''
      if (ObjectUtil.isNotEmpty(topName)) {
        eName = topName!
      } else {
        eName = NavRootEvent
      }
      const state = this.getCurrentState()
      if (!state.redirectWithResultMode) {
        this.unregisterEvent(eName)
      }
      this.registerEvent<T>(eName, param, callback)
    })
      .catch((e: Error) => {
        LogUtil.error('error: ', e)
      })

  }

  /**
   * 携带结果重定向到指定页面
   * @deprecated
   * @see {redirectForResult2}
   * @param name
   * @param param
   * @param callback
   */
  public redirectForResult(name: string, param?: ObjectOrNull, callback?: OnPopCallback) {
    this.pop(false)
    this.pushForResult<ObjectOrNull>(name, param, callback)
  }


  /**
   * 携带结果重定向到指定页面
   * redirectForResult2 - finishWithResult
   * @see {finishWithResult}
   * @param name
   * @param param
   * @param callback
   */
  public redirectForResult2<T>(name: string, param?: ObjectOrNull, callback?: OnPopResultCallback<T>,
    builder?: NavBuilder<T>) {
    const state = this.getCurrentState()
    state.redirectInfo.name = state.stackTopInfo?.metadata?.name || ''
    this.pop(false)
    state.redirectWithResultMode = true
    this.push<T>(name, param, true)
    this.unregisterEvent(state.redirectInfo.name)
    this.registerEvent<T>(state.redirectInfo.name, param, callback)
  }

  /**
   * 重定向页面
   * @param name
   */
  public redirect<T>(name: string, builder?: NavBuilder<T>) {
    this.pop(false)
    this.pushForResult<ObjectOrNull>(name, builder)
  }


  private pushDestination<T>(name: string, param?: ObjectOrNull, callback?: OnPopCallback,
    builder?: NavBuilder<T>) {
    return this.getNavStack()
      .pushDestination({
        name, param: param, onPop: (data) => {
          callback?.(data)
        }
      }, { launchMode: builder?.options?.lunchMode, animated: builder?.options.animated ?? true })
      .catch((err: BusinessError) => {
        LogUtil.error('error: ', err.code, err.message)
        if (err.code == ErrorCode.NOT_REGISTERED) {
          const state = this.getCurrentState()
          let interceptorInfo = InterceptorInfo.create(true)
          interceptorInfo.name = name
          interceptorInfo.param = param
          this.interceptorMgr.run(state.stackName, interceptorInfo, true, (it) => {
            it.onNavigate?.(interceptorInfo)
          })
        }
      })
  }

  /**
   * 关闭到指定名称页面
   * @param name
   * @param animated
   */
  public popToName(name: string, animated: boolean = true) {
    this.getNavStack().popToName(name, animated)
  }

  /**
   * 返回上一页
   * @param animated
   */
  public pop(animated: boolean = true) {
    this.getNavStack().pop(animated)
  }

  /**
   * 带结果的关闭页面
   * pushForResult - popWithResult
   * 场景 A->B， B->A ，A监听B的返回结果
   * @see {pushForResult}
   * @param result
   * @param animated
   */
  public popWithResult(result?: Object, animated: boolean = true) {
    // 路由栈处理结果不支持Boolean类型，转成字符串携带
    if (typeof result == "boolean") {
      result = result + ""
    }
    this.getNavStack().pop(result, animated)
  }


  /**
   * 带结果的关闭页面 ，必须与pushNavForResult配合使用
   * 场景 A->B->C->D ，D->C->B->A ，A监听D的返回结果
   * @see {pushNavForResult}
   * @param name 路由名称
   * @param result
   * @param animated
   */
  public popNavWithResult<T>(name: string, result?: T, animated: boolean = true) {
    const currentName = this.getTopPathName()
    if (ObjectUtil.isEmpty(currentName)) {
      LogUtil.error(currentName + " 不存在路由栈顶中")
      return;
    }
    if (ObjectUtil.isNotEmpty(name) && this.getAllPathName().includes(name!)) {
      if (currentName !== name) {
        this.getNavStack().popToName(name, result, animated)
      } else {
        LogUtil.error('不支持关闭当前页， 请使用popWithResult')
      }
    } else {
      LogUtil.error(name + " 不存在路由栈中")
      return
    }
    this.sendEvent<T>(name!, currentName!, result)

  }

  /**
   * 必须与redirectForResult2配合使用，用于回调redirectForResult2中的callback
   * @see {redirectForResult2}
   * @param result
   * @param animated
   */
  public finishWithResult<T>(result?: T, animated: boolean = true) {
    const state = this.getCurrentState()
    if (state.redirectWithResultMode && ObjectUtil.isNotEmpty(state.redirectInfo.name)) {
      const topName = this.getTopPathName()
      this.sendEvent<T>(state.redirectInfo.name, topName!, result)
      this.pop(animated)
    }
  }


  public popToRootWithResult<T>(result?: T, animated: boolean = true) {
    const currentName = this.getTopPathName()
    if (ObjectUtil.isEmpty(currentName)) {
      LogUtil.error(currentName + " 不存在路由栈顶中")
      return;
    }
    this.getNavStack().clear(animated)
    const name = NavRootEvent
    this.sendEvent<T>(name!, currentName!, result)
  }


  public setInterceptor<T extends IInterceptor>(interceptor: T, stackName: string = DEFAULT_STACK_NAME) {
    this.interceptorMgr.addInterceptor(stackName, interceptor)
  }


  /**
   * 清空页面栈，返回Navigation主页
   */
  public clear() {
    this.getNavStack().clear()
  }


  public getAllPathName(): string[] {
    return this.getNavStack().getAllPathName()
  }

  public getTopPathName(): string | null {
    let length = this.getAllPathName().length
    if (length > 0) {
      let name = this.getAllPathName()[length-1]
      return name
    }
    return null
  }


  public pushByTopName(param?: ObjectOrNull, remove: boolean = true) {
    try {
      const state = this.getCurrentState()
      let name = this.getTopPathName()
      if (state.redirectWithResultMode) {
        name = state.redirectInfo.name
      } else {
        if (ObjectUtil.isEmpty(name)) {
          name = state.stackTopInfo?.metadata?.name || state.redirectInfo.name
        }
      }

      if (name) {
        if (remove) {
          this.getNavStack().removeByName(name)
        }
        this.push<ObjectOrNull>(name, param, true)
      }
    } catch (e) {
      LogUtil.error('error: ', e)
    }
  }

  /**
   * 获取跳转携带的参数
   * @param name
   * @returns
   */
  public getParamByName(name: string): Record<string, ObjectOrNull>[] {
    return this.getNavStack().getParamByName(name) as Record<string, ObjectOrNull>[]
  }

  /**
   * 获取页面携带的参数
   * @returns
   */
  public getParam(): ObjectOrNull {
    let name = this.getTopPathName()
    if (!name) {
      const state = this.getCurrentState()
      name = state.stackTopInfo?.metadata?.name ?? ""
    }
    if (name) {
      try {
        let params = this.getParamByName(name)
        return params[params.length-1]
      } catch (e) {
        LogUtil.error('err: ', e)
        return null
      }
    } else {
      return null
    }

  }

  /**
   * 获取栈顶的装饰器参数
   * @returns
   */
  public getAnnotationParam(): RouteMetadata | undefined {
    const state = this.getCurrentState()
    return state.stackTopInfo?.metadata
  }

  public removeByName(name: string) {
    this.getNavStack().removeByName(name)
  }

  public moveToTop(name: string) {
    this.getNavStack().moveToTop(name)
  }

  public replacePathByName<T>(name: string, param?: ObjectOrNull, animated: boolean = true,
    builder?: NavBuilder<T>) {
    this.getNavStack()
      .replacePath({ name, param },
        { launchMode: builder?.options?.lunchMode, animated: builder?.options.animated ?? animated })
  }

  private isRegisterEvent(name: string) {
    return emitter.getListenerCount(name) > 0
  }

  private registerEvent<T>(name: string, param?: ObjectOrNull, callback?: OnPopResultCallback<T>) {
    emitter.on(name, (data: emitter.EventData) => {
      let r = callback?.(data.data as PopResult<T>)
      if (typeof r === 'boolean' && r) {
        const state = this.getCurrentState()
        if (state.redirectWithResultMode) {
          this.pushByTopName(param)
          // 所有的状态复原，包括事件的注册
          state.redirectWithResultMode = false
          state.redirectInfo.name = ''
          this.unregisterEvent(name)
        }

      }
    })
  }

  private unregisterEvent(name: string) {
    if (this.isRegisterEvent(name)) {
      let n = emitter.getListenerCount(name);
      for (let i = 0; i < n; i++) {
        emitter.off(name)
      }
    }
  }

  private sendEvent<T>(name: string, from: string, result?: T) {
    if (this.isRegisterEvent(name)) {
      const r = new PopResult<T>()
      r.data = result
      r.from = from
      emitter.emit(name, { data: r })
    }
  }


  public setGlobalInterceptor(interceptor: IGlobalNavigateInterceptor, stackName: string = DEFAULT_STACK_NAME) {
    this.interceptorMgr.setGlobalInterceptor(stackName, interceptor)
  }

  /**
   * @deprecated
   * @see {setInterceptor}
   * @param callback
   */
  public addGlobalInterceptor(callback: (info: InterceptorInfo) => void) {
    this.setGlobalInterceptor({
      onNavigate: (context) => {
        callback(context)
      }
    } as IGlobalNavigateInterceptor)
  }


  /**
   * @deprecated
   * @param stackName
   * @param name
   * @param param
   * @param animated
   */
  public pushByStackName(stackName: string, name: string, param?: ObjectOrNull, animated: boolean = false) {
    this.getNavStackByName(stackName).pushPathByName(name, param, animated)
  }
}