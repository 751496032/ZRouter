/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjectUtil } from '../utlis/ObjectUtil'
import { InterceptorInfo, ObjectOrNull, OnInterceptorCallback, OnPopCallback, RouteMapData } from '../model/Model'
import { BusinessError } from '@kit.BasicServicesKit'


export class RouterMgr {
  private stackMap: Map<string, NavPathStack> = new Map<string, NavPathStack>()
  private interceptions: Map<string, OnInterceptorCallback> =
    new Map<string, OnInterceptorCallback>()
  private pageInfoFromStackTop: InterceptorInfo | undefined

  private constructor() {
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
          if (operation === NavigationOperation.PUSH) {
            const interceptorInfo = new InterceptorInfo()
            try {
              const toContext: NavDestinationContext = to as NavDestinationContext
              interceptorInfo.toContext = toContext
              const data = toContext.getConfigInRouteMap()?.data
              if (ObjectUtil.isObject(data)) {
                const mapData: RouteMapData = data as RouteMapData
                mapData.name = toContext.getConfigInRouteMap()?.name
                interceptorInfo.data = mapData
              }
              this.pageInfoFromStackTop = interceptorInfo
            } catch (e) {
              console.error('ZRouter: 页面配置错误，请检查是否正确配置')
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

  public pushByStackName(stackName: string, name: string, param?: ObjectOrNull) {
    this.getNavStackByName(stackName).pushPathByName(name, param)
  }

  /**
   * 页面跳转
   * @param name 是Route装饰器上的name
   * @param param 携带的参数
   */
  public push(name: string, param?: ObjectOrNull) {
    this.getNavStack().pushPathByName(name, param)
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
          this.pushByTopName()
        }
      }
    })
  }

  public redirectForResult(name: string, param?: ObjectOrNull, callback?: OnPopCallback) {
    this.pop()
    this.pushForResult(name, param, callback)
  }

  public redirect(name: string) {
    this.redirectForResult(name)
  }

  public popToName(name: string) {
    this.getNavStack().popToName(name)
  }

  public pop() {
    this.getNavStack().pop()
  }

  public popWithResult(result?: Object) {
    this.getNavStack().pop(result, false)
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


  public pushByTopName(remove: boolean = true) {
    try {
      // if (this.pageInfoFromStackTop?.data?.extra === 'hsp') {
      //   let param = this.pageInfoFromStackTop?.toContext?.pathInfo?.param as Object[]
      //   this.push(this.pageInfoFromStackTop?.data?.name, param)
      //   return
      // }
      let name = this.getTopPathName()
      if (!name) {
        name = this.pageInfoFromStackTop?.data?.name ?? null
      }
      if (name) {
        let param: Object[] = this.getNavStack().getParamByName(name) as Object[]
        if (ObjectUtil.isEmpty(param)) {
          param = this.pageInfoFromStackTop?.toContext?.pathInfo?.param as Object[]
        }
        if (remove) {
          this.getNavStack().removeByName(name)
        }
        this.push(name, param)
      }
    } catch (e) {
      console.error('ZRouter: ',e )
    }
  }
}