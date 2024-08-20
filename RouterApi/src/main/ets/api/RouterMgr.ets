/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjectUtil } from '../utlis/ObjectUtil'
import { InterceptorInfo,
  NavRootEvent,
  ObjectOrNull, OnInterceptorCallback, OnPopCallback,
  OnPopResultCallback,
  PopResult,
  RouteMetadata } from '../model/Model'
import LogUtil from '../utlis/LogUtil'
import { emitter } from '@kit.BasicServicesKit'
import { ArrayList } from '@kit.ArkTS'
import uiObserver from '@ohos.arkui.observer';


export class RouterMgr {
  private stackMap: Map<string, NavPathStack> = new Map<string, NavPathStack>()
  private interceptions: Map<string, OnInterceptorCallback> =
    new Map<string, OnInterceptorCallback>()
  private pageInfoFromStackTop: InterceptorInfo | undefined
  private registerEventNames = new ArrayList<string>()

  private constructor() {
    uiObserver.on('navDestinationUpdate', (info) => {
       const name =  info.name.toString()
      switch (info.state) {
        case uiObserver.NavDestinationState.ON_WILL_DISAPPEAR:
          LogUtil.log(name, 'onWillDisappear')
          break
        case uiObserver.NavDestinationState.ON_DISAPPEAR:
          const indexList = this.getNavStack().getIndexByName(name)
          LogUtil.log(name, 'onDisappear: ' + indexList.length)
          if (indexList.length == 0) {
            this.unregisterEvent(name)
          }
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

  public registerNavStack(stackName: string = '', pathStack: NavPathStack): void {
    if (!this.stackMap.has(stackName)) {
      this.stackMap.set(stackName, pathStack)
      pathStack.setInterception({
        willShow: (from: NavDestinationContext | NavBar, to: NavDestinationContext | NavBar,
          operation: NavigationOperation, animated: boolean) => {
          LogUtil.log('operation: ', operation)
          if (operation === NavigationOperation.PUSH) {
            const interceptorInfo = new InterceptorInfo()
            try {
              const toContext: NavDestinationContext = to as NavDestinationContext
              interceptorInfo.toContext = toContext
              const data = toContext.getConfigInRouteMap()?.data
              if (ObjectUtil.isObject(data)) {
                const mapData: RouteMetadata = data as RouteMetadata
                mapData.name = toContext.getConfigInRouteMap()?.name
                interceptorInfo.data = mapData
              }
              this.pageInfoFromStackTop = interceptorInfo
            } catch (e) {
              LogUtil.error('push: 页面配置错误，请检查是否正确配置')
            } finally {
              this.interceptions.forEach((callback) => {
                callback(interceptorInfo)
              })
            }
          }
        }
      })
    }
  }

  public getNavStack(): NavPathStack {
    return this.getNavStackByName('')
  }

  public getNavStackByName(stackName: string): NavPathStack {
    let stack = this.stackMap.get(stackName)
    if (stack !== undefined && stack !== null) {
      return stack as NavPathStack
    }
    stack = new NavPathStack()
    this.registerNavStack(stackName, stack)
    return stack
  }

  public pushByStackName(stackName: string, name: string, param?: ObjectOrNull, animated: boolean = false) {
    this.getNavStackByName(stackName).pushPathByName(name, param, animated)
  }

  /**
   * 页面跳转
   * @param name 是Route装饰器上的name属性值
   * @param param 携带的参数
   */
  public push(name: string, param?: ObjectOrNull, animated: boolean = false) {
    this.getNavStack().pushPathByName(name, param, animated)
  }

  /**
   * 页面跳转 可监听返回结果，需与popWithResult配合使用
   * @see {popWithResult}
   * @param name
   * @param param
   * @param callback
   */
  public pushForResult(name: string, param?: ObjectOrNull, callback?: OnPopCallback) {
    this.getNavStack().pushPath({
      name, param: param, onPop: (data) => {
        let r = callback?.(data)
        // 默认实现逻辑，一般与登录配合使用
        if (typeof r === 'boolean' && r) {
          this.pushByTopName(param)
        }
      }
    })
  }

  /**
   * 监听返回结果跳转，必须与popNavWithResult配合使用
   * @see {popNavWithResult}
   * @param name
   * @param param
   * @param callback
   */
  public pushNavForResult<T>(name: string, param?: ObjectOrNull, callback?: OnPopResultCallback<T>) {
    const topName = this.getTopPathName()
    this.getNavStack().pushDestinationByName(name, param).then(() => {
      let eName = ''
      if (ObjectUtil.isNotEmpty(topName)) {
        eName = topName!
      } else {
        eName = NavRootEvent
      }
      this.unregisterEvent(eName)
      this.registerEvent<T>(eName, callback)
    })
      .catch((e: Error) => {
        LogUtil.error('error: ', e)
      })

  }

  /**
   * 携带结果重定向页面
   * @param name
   * @param param
   * @param callback
   */
  public redirectForResult(name: string, param?: ObjectOrNull, callback?: OnPopCallback) {
    this.pop(false)
    this.pushForResult(name, param, callback)
  }

  /**
   * 重定向页面
   * @param name
   */
  public redirect(name: string) {
    this.redirectForResult(name)
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
   * 关闭当前页面
   * @param animated
   */
  public pop(animated: boolean = true) {
    this.getNavStack().pop(animated)
  }

  /**
   * 带结果的关闭页面
   * @see {popWithResult}
   * @param result
   * @param animated
   */
  public popWithResult(result?: Object, animated: boolean = true) {
    this.getNavStack().pop(result, animated)
  }


  /**
   * 带结果的关闭页面 ，必须与pushNavForResult配合使用
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
    }else {
      LogUtil.error(name + " 不存在路由栈中")
      return
    }
    this.sendEvent<T>(name!,currentName!, result)

  }


  public popToRootWithResult<T>(result?: T, animated: boolean = true){
    const currentName = this.getTopPathName()
    if (ObjectUtil.isEmpty(currentName)) {
      LogUtil.error(currentName + " 不存在路由栈顶中")
      return;
    }
    this.getNavStack().clear(animated)
    const name = NavRootEvent
    this.sendEvent<T>(name!,currentName!, result)
  }



  public addGlobalInterceptor(callback: (info: InterceptorInfo) => void) {
    this.addInterceptor('', callback)
  }

  public addInterceptor(key: string, callback: (info: InterceptorInfo) => void) {
    this.interceptions.set(key, callback)
  }


  public removeInterceptor(key: string) {
    if (!key && key.trim().length > 0) {
      this.interceptions.delete(key)
    }
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


  public  pushByTopName(param?: ObjectOrNull, remove: boolean = true) {
    try {
      let name = this.getTopPathName()
      if (!name) {
        name = this.pageInfoFromStackTop?.data?.name ?? null
      }
      if (name) {
        // if (ObjectUtil.isEmpty(param)) {
        //    param = this.getParamByName(name) as ObjectOrNull
        //   if (ObjectUtil.isEmpty(param)) {
        //     param = this.pageInfoFromStackTop?.toContext?.pathInfo?.param as ObjectOrNull
        //   }
        // }
        if (remove) {
          this.getNavStack().removeByName(name)
        }
        this.push(name, param)
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
      name = this.pageInfoFromStackTop?.data?.name ?? ""
    }
    if (name) {
      try {
        return this.getParamByName(name)[0]
      } catch (e) {
        LogUtil.error('err: ', e)
        return null
      }
    } else {
      return null
    }

  }

  /**
   * 获取栈顶页面的装饰器参数
   * @returns
   */
  public getAnnotationParam(): RouteMetadata | undefined {
    return this.pageInfoFromStackTop?.data
  }

  public removeByName(name: string) {
    this.getNavStack().removeByName(name)
  }

  public moveToTop(name: string) {
    this.getNavStack().moveToTop(name)
  }

  public replacePathByName(name: string, param?: ObjectOrNull,animated: boolean = true) {
    this.getNavStack().replacePathByName(name, param, animated)
  }

  private isRegisterEvent(name: string) {
    return emitter.getListenerCount(name) > 0
  }

  private registerEvent<T>(name: string, callback?: OnPopResultCallback<T>) {
    emitter.on(name, (data: emitter.EventData) => {
      callback?.(data.data as PopResult<T>)
    })
  }

  private unregisterEvent(name: string) {
    if (this.isRegisterEvent(name)) {
     let n =  emitter.getListenerCount(name);
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
}