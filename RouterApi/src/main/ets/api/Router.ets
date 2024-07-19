/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjectUtil } from '../utlis/ObjectUtil'
import { InterceptorInfo, RouteMapData } from './Model'


export class ZRouter {
  private static stackMap: Map<string, NavPathStack> = new Map<string, NavPathStack>()
  private static interceptions: Map<string, (info: InterceptorInfo) => void> =
    new Map<string, (info: InterceptorInfo) => void>()

  private constructor() {
  }

  public static registerNavStack(stackName: string = '', pathStack: NavPathStack): void {
    if (!ZRouter.stackMap.has(stackName)) {
      ZRouter.stackMap.set(stackName, pathStack)
      pathStack.setInterception({
        willShow: (from: NavDestinationContext | NavBar, to: NavDestinationContext | NavBar,
          operation: NavigationOperation, animated: boolean) => {
          if (operation === NavigationOperation.PUSH) {
            const fromContext: NavDestinationContext = from as NavDestinationContext
            const toContext: NavDestinationContext = to as NavDestinationContext
            const interceptorInfo = new InterceptorInfo(fromContext, toContext)
            const data = toContext.getConfigInRouteMap()?.data
            if (ObjectUtil.isObject(data)) {
              const mapData: RouteMapData = data as RouteMapData
              mapData.name = toContext.getConfigInRouteMap()?.name
              interceptorInfo.data = mapData
            }
            ZRouter.interceptions.forEach((callback) => {
              callback(interceptorInfo)
            })
          }

        }
      })
    }
  }

  public static getNavStack(): NavPathStack {
    return ZRouter.getNavStackByName('')
  }

  public static getNavStackByName(stackName: string): NavPathStack {
    let stack = ZRouter.stackMap.get(stackName)
    if (stack !== undefined && stack !== null) {
      return stack as NavPathStack
    }
    stack = new NavPathStack()
    ZRouter.registerNavStack(stackName, stack)
    return stack
  }

  public static pushByStackName(stackName: string, name: string, param?: Object) {
    ZRouter.getNavStackByName(stackName).pushPathByName(name, param)
  }

  public static push(name: string, param?: Object) {
    ZRouter.getNavStack().pushPathByName(name, param)
  }

  /**
   * 监听上一页返回时携带的数据
   * @see {popWithResult}
   * @param name
   * @param param
   * @param callback
   */
  public static pushForResult(name: string, param?: Object | undefined | null, callback?: (data: PopInfo) => void) {
    ZRouter.getNavStack().pushPath({
      name, param: param, onPop: (data) => {
        callback?.(data)
      }
    })
  }

  public static pushWithNoParamForResult(name: string, callback?: (data: PopInfo) => void) {
    ZRouter.pushForResult(name, null, callback)
  }

  public static popToName(name: string) {
    ZRouter.getNavStack().popToName(name)
  }

  public static pop() {
    ZRouter.getNavStack().pop()
  }

  public static popWithResult(result?: Object) {
    ZRouter.getNavStack().pop(result,false)
  }

  public static addGlobalInterceptor(callback: (info: InterceptorInfo) => void) {
    ZRouter.addInterceptor('', callback)
  }

  public static addInterceptor(key: string, callback: (info: InterceptorInfo) => void) {
    ZRouter.interceptions.set(key, callback)
  }


  public static removeInterceptor(key: string) {
    if (!key && key.trim().length > 0) {
      ZRouter.interceptions.delete(key)
    }
  }

  public static clear() {
    ZRouter.getNavStack().clear()
  }
}