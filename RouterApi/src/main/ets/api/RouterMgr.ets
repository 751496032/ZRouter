/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjUtil } from '../utlis/ObjUtil'
import {
  DEFAULT_STACK_NAME,
  DestinationInfo,
  InterceptorInfo,
  InterceptorInfoOrNull,
  NavigationAction,
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
import { NavDestBuilder } from '../model/NavDestBuilder'
import { ErrorCode, RedirectType } from '../model/Const'
import { ServiceMgr } from '../service/ServiceMgr';
import { LifecycleMgr } from '../lifecycle/LifecycleMgr';
import { RouterInfo } from '../model/RouterInfo';
import { LifecycleEvent } from '../lifecycle/LifecycleEvent';
import { NavAnimationMgr } from '../animation/NavAnimationMgr';
import { DeviceUtil } from '../utlis/DeviceUtil';
import { INavDestOptions } from '../model/NavDestOptions';


export class RouterMgr {
  private interceptorMgr = InterceptorMgr.getInstance()
  private navStackMgr = NavStackMgr.getInstance()
  private _serviceMgr = ServiceMgr.getInstance()
  private _lifecycleMgr = LifecycleMgr.getInstance()
  private _animateMgr = NavAnimationMgr.getInstance()
  /**
   * 只有使用了服务路由才会生效，判断是否已经完成了模块的动态加载
   */
  public isDynamicLoadedComplete = false
  public moduleLoadedListener?: () => void
  private hasPageBeenLaunched = false
  /**
   * 是否隐藏Navigation根视图
   */
  public hideNavbar = false

  private constructor() {
    uiObserver.on('navDestinationUpdate', (info) => {
      if (!this.hasPageBeenLaunched) {
        this.hasPageBeenLaunched = true
      }
      const name = info.name.toString()
      if (ObjUtil.isEmpty(name)) {
        return
      }
      const routerInfo = RouterInfo.create(name, info.navigationId.toString(), info.param, info.navDestinationId)
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
          this.getCurrentState().deleteDestOptions(name)
          this.navStackMgr.removeRouterInfo(routerInfo)
          const indexList = this.getNavStack().getIndexByName(name)
          if (indexList.length == 0 && !this.getCurrentState().redirectWithResultMode) {
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
          this.navStackMgr.addRouterInfo(routerInfo)
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_WILL_APPEAR, routerInfo)
          break
        case uiObserver.NavDestinationState.ON_WILL_DISAPPEAR:
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_WILL_DISAPPEAR, routerInfo)
          break
        case uiObserver.NavDestinationState.ON_BACKPRESS:
          this._lifecycleMgr.notifyObservers(LifecycleEvent.ON_BACK_PRESS, routerInfo)
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

  public serviceMgr(): ServiceMgr {
    return this._serviceMgr
  }

  public get lifecycleMgr(): LifecycleMgr {
    return this._lifecycleMgr
  }

  public get animateMgr(): NavAnimationMgr {
    return this._animateMgr
  }

  public setCurrentStackName(name: string) {
    this.navStackMgr.updateCurrentStackName(name)
  }

  public get currentStackName(): string {
    return this.navStackMgr.currentStackName
  }

  public getLastNavDestinationId(): string | undefined {
    return this.navStackMgr.getLastNavDestinationId()
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
    this.navStackMgr.updateCurrentStackName(stackName)
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
    return this.navStackMgr.getNavDestState()
  }


  /**
   * 页面跳转
   * @param name 是Route装饰器上的name属性值
   * @param param 携带的参数
   */
  public push<T>(name: string, param?: ObjectOrNull, animated: boolean = false, builder?: NavDestBuilder<T>):Promise<void>  {
    return this.pushDestination<T>(name, param, undefined, builder)
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
    builder?: NavDestBuilder<T>): Promise<void> {
    return this.pushDestination<T>(name, param, callback, builder)
  }

  /**
   * 监听返回结果跳转，必须与popNavWithResult配合使用
   * 当跳转多个页面，并且返回需要携带结果时使用
   * 比如 A->B->C->D 当页面在D时，需要返回到A并携带结果，此时在A就可以监听D的返回结果
   * pushNavForResult - popNavWithResult 或 popToNameWithResult
   * pushNavForResult - popToRootWithResult
   * @see {popNavWithResult}
   * @param name
   * @param param
   * @param callback
   */
  public pushNavForResult<T>(name: string, param?: ObjectOrNull, callback?: OnPopResultCallback<T>,
    builder?: NavDestBuilder<T>): Promise<void> {
    const topName = this.getTopPathName()
    return this.pushDestination(name, param, undefined, builder).then(() => {
      let eName = ''
      if (ObjUtil.isNotEmpty(topName)) {
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
   * redirectForResult2 - finishWithResult
   * @see {finishWithResult}
   * @param name
   * @param param
   * @param callback
   */
  public redirectForResult2<T>(name: string, param?: ObjectOrNull, callback?: OnPopResultCallback<T>,
    builder?: NavDestBuilder<T>) {
    const redirectType = builder?.options?.redirectType
    const state = this.getCurrentState()
    state.redirectInfo.name = state.stackTopInfo?.metadata?.name || ''
    state.redirectWithResultMode = true
    state.redirectInfo.type = redirectType
    if (redirectType == RedirectType.REPLACE) {
      this.getNavStack().replacePathByName(name, param, builder?.options.animated)
    } else if (redirectType == RedirectType.REMOVE) {
      const topName = this.getTopPathName()
      this.push<T>(name, param, true).then(() => {
        setTimeout(() => {
          if (topName) {
            this.removeByName(topName)
          }
        }, 500)
      })
    }else {
      this.pop(false)
      this.push<T>(name, param, true)
    }
    this.unregisterEvent(state.redirectInfo.name)
    this.registerEvent<T>(state.redirectInfo.name, param, callback)
  }

  /**
   * 重定向页面
   * @param name
   */
  public redirect<T>(name: string, builder?: NavDestBuilder<T>) {
    const redirectType = builder?.options?.redirectType
    if (redirectType === RedirectType.REPLACE) {
      this.replacePathByName(name, builder?.getParam(), builder?.options.animated, builder)
    } else if (redirectType === RedirectType.REMOVE) {
      const topName = this.getTopPathName()
      this.pushForResult<ObjectOrNull>(name, builder)
      setTimeout(() => {
        if (topName) {
          this.removeByName(topName)
        }
      },500)
    } else {
      this.pop(false)
      this.pushForResult<ObjectOrNull>(name, builder)
    }

  }


  private async pushDestination<T>(name: string, param?: ObjectOrNull, callback?: OnPopCallback,
    builder?: NavDestBuilder<T>) {
    const animated = builder?.options.animated ?? true
    const launchMode = builder?.options?.lunchMode
    const r = await this.beforePushOrReplace(name, NavigationOperation.PUSH, param, builder)
    if (r.isContinue()) {
      param = r.param
      name = r.name
    } else {
      return Promise.resolve()
    }
    if (DeviceUtil.isSdkVersion12()) {
      return this.getNavStack()
        .pushDestination({
          name, param: param, onPop: (data) => {
            callback?.(data)
          }
        }, { launchMode: launchMode, animated: animated })
        .catch((err: BusinessError) => {
          this.handlePushError(err, name, param, builder)
        })
    } else {
      return this.getNavStack()
        .pushDestination({
          name, param: param, onPop: (data) => {
            callback?.(data)
          }
        }, animated)
        .catch((err: BusinessError) => {
          this.handlePushError(err, name, param ,builder)
        })
    }
  }

  private handlePushError<T>(err: BusinessError, name: string, param?: ObjectOrNull, builder?: NavDestBuilder<T>) {
    LogUtil.error('error: ', err.code, err.message)
    if (err.code == ErrorCode.NOT_REGISTERED) {
      const state = this.getCurrentState()
      let interceptorInfo = InterceptorInfo.create(true)
      interceptorInfo.name = name
      interceptorInfo.param = param
      interceptorInfo.navigationOptions = builder?.options as INavDestOptions<ObjectOrNull>
      this.interceptorMgr.run(state.stackName, interceptorInfo, true, (it) => {
        it.onNavigate?.(interceptorInfo)
      })
    }
  }


  private async beforePushOrReplace<T>(name: string, operation: NavigationOperation, param?: ObjectOrNull,
    builder?: NavDestBuilder<T>): Promise<DestinationInfo> {
    const state = this.getCurrentState()
    let interceptorInfo = InterceptorInfo.create(true)
    interceptorInfo.name = name
    interceptorInfo.param = param
    interceptorInfo.operation = operation
    let r: DestinationInfo  = DestinationInfo.create(interceptorInfo)
    try {
      r.navigationOptions = builder?.options as INavDestOptions<ObjectOrNull>
      if (builder) {
        state.setDestOptions(name, r.navigationOptions)
      }
      const interceptor = this.interceptorMgr.getGlobalInterceptor(state.stackName)
      const result = await interceptor?.onNavigateBefore?.(r)
      if (result) {
        r = result
      }
    } catch (error) {
      LogUtil.error('beforePushOrReplace error: ', error)
    }
    if (!r.isContinue()) {
      LogUtil.log('beforePushOrReplace next: ',  r.isContinue())
    }
    return r
  }

  /**
   * 关闭到指定名称页面
   * @param name
   * @param animated
   * @returns 页面在栈中的索引index
   */
  public popToName(name: string, animated: boolean = true) {
    return this.popToNameInternal(name, undefined, animated)
  }


  /**
   * 关闭到指定名称页面，并携带结果
   * @param name
   * @param result
   * @param animated
   * @returns
   */
  public popToNameWithResult<T>(name: string, result?: T, animated: boolean = true) {
    return this.popToNameInternal(name, result, animated)
  }

  /**
   * 返回上一页
   * @param animated
   * @returns boolean true: 表示成功关闭页面
   */
  public pop(animated: boolean = true) {
    return this.popInternal(undefined, animated)
  }

  /**
   * 带结果的关闭页面
   * pushForResult - popWithResult
   * 场景 A->B， B->A ，A监听B的返回结果
   * @see {pushForResult}
   * @param result
   * @param animated
   * @returns boolean true: 表示成功关闭页面
   */
  public popWithResult(result: Object, animated: boolean = true) {
    return this.popInternal(result, animated)
  }


  private popInternal(result?: Object, animated: boolean = true): boolean {
    // 路由栈默认是不支持Boolean类型，转成字符串携带
    if (typeof result == "boolean") {
      result = `${result}`
    }
    if (this.isHideNavbarModeWithEmptyStack()) {
      return false
    }
    if (result) {
      let r = this.getNavStack().pop(result, animated)
      if (!r) {
        r = this.getNavStack().getParent()?.pop(result, animated)
      }
      return r !== undefined
    } else {
      let r = this.getNavStack().pop(animated)
      if (!r) {
        r = this.getNavStack()?.getParent()?.pop(animated)
      }
      return r !== undefined
    }
  }

  private isHideNavbarModeWithEmptyStack(): boolean {
    return this.hideNavbar && this.getIndexesExceptBottom().length === 0
  }

  private popToNameInternal<T>(name: string, result?: T, animated: boolean = true): number {
    let index = -1
    if (this.isHideNavbarModeWithEmptyStack()) {
      return index
    }
    if (result) {
      index = this.getNavStack().popToName(name, result!, animated)
      if (index === -1) {
        index = this.getNavStack()?.getParent()?.popToName(name, result!, animated) ?? -1
      }
    } else {
      index = this.getNavStack().popToName(name, animated)
      if (index === -1) {
        index = this.getNavStack()?.getParent()?.popToName(name, animated) ?? -1
      }
    }
    return index
  }


  /**
   * 带结果的关闭页面 ，必须与pushNavForResult配合使用
   * 场景 A->B->C->D ，D->C->B->A ，A监听D的返回结果
   * @see {pushNavForResult}
   * @param name 路由名称
   * @param result
   * @param animated
   * @deprecated 建议使用popToNameWithResult()方法，该方法已经被弃用
   */
  public popNavWithResult<T>(name: string, result: T, animated: boolean = true) {
    const currentName = this.getTopPathName()
    if (ObjUtil.isEmpty(currentName)) {
      LogUtil.error(currentName + " 不存在路由栈顶中")
      return;
    }
    if (ObjUtil.isNotEmpty(name) && this.getAllPathName().includes(name!)) {
      if (currentName !== name) {
        this.popToNameWithResult(name, result!, animated)
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
  public finishWithResult<T>(result: T, animated: boolean = true): boolean {
    const state = this.getCurrentState()
    if (state.redirectWithResultMode && ObjUtil.isNotEmpty(state.redirectInfo.name)) {
      const topName = this.getTopPathName()
      this.sendEvent<T>(state.redirectInfo.name, topName!, result)
      this.pop(animated)
      return true
    }
    return false
  }


  public popToRootWithResult<T>(result: T, animated: boolean = true) {
    const currentName = this.getTopPathName()
    if (ObjUtil.isEmpty(currentName)) {
      LogUtil.error('路由栈为空，无法执行popToRootWithResult')
      return;
    }
    this.clear(animated)
    const name = !this.hideNavbar ? NavRootEvent : this.getBottomPathName() ?? NavRootEvent
    this.sendEvent<T>(name!, currentName!, result)
  }


  public setInterceptor<T extends IInterceptor>(interceptor: T, stackName: string = DEFAULT_STACK_NAME) {
    this.interceptorMgr.addInterceptor(stackName, interceptor)
  }


  public removeInterceptor<T extends IInterceptor>(interceptor: T, stackName: string = DEFAULT_STACK_NAME): boolean {
    return this.interceptorMgr.removeInterceptor(stackName, interceptor)
  }


  /**
   * 清空页面栈，返回Navigation 根视图
   */
  public clear(animated: boolean = true) {
    if (!this.hideNavbar) {
      this.getNavStack().clear(animated)
    } else {
      const indexes: number[] = this.getIndexesExceptBottom()
      this.getNavStack().removeByIndexes(indexes)
    }
  }

  /**
   * 获取除栈底外的所有元素索引
   * @returns
   */
  private getIndexesExceptBottom(): number[] {
    const indexes: number[] = []
    this.getAllPathName().forEach((name, index) => {
      if (index > 0) {
        indexes.push(index)
      }
    })
    return indexes
  }

  /**
   * 获取栈底元素名称
   * @returns
   */
  private getBottomPathName(): string | null {
    const allPaths = this.getAllPathName()
    if (allPaths.length > 0) {
      return allPaths[0]  // 栈底元素索引为0
    }
    return null
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
        if (ObjUtil.isEmpty(name)) {
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

  public async replacePathByName<T>(name: string, param?: ObjectOrNull, animated: boolean = true,
    builder?: NavDestBuilder<T>) {
    const anim = builder?.options.animated ?? animated
    const launchMode = builder?.options?.lunchMode
    const r = await this.beforePushOrReplace(name, NavigationOperation.REPLACE, param, builder)
    if (r.isContinue()) {
      param = r.param
    } else {
      return
    }
    if (DeviceUtil.isSdkVersion12()) {
      this.getNavStack()
        .replacePath({ name, param },
          { launchMode: launchMode, animated: anim })
    } else {
      this.getNavStack().replacePath({ name, param }, anim)
    }

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