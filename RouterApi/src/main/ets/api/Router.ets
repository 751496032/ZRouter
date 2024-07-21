/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjectUtil } from '../utlis/ObjectUtil'
import { InterceptorInfo, ObjectOrNull, OnPopCallback } from '../model/Model'
import { RouterMgr } from './RouterMgr'

const KEY_Z_ROUTER = 'ZRouter'

export class ZRouter {
  private static routerMgr: RouterMgr | undefined = undefined

  private constructor() {
  }

  public static init(isHspModuleExist: boolean = false) {
    ZRouter.routerMgr = RouterMgr.getInstance()
    if (isHspModuleExist) {
      AppStorage.setOrCreate(KEY_Z_ROUTER, ZRouter.routerMgr)
    }
  }

  private static getRouterMgr(): RouterMgr {
    if (ZRouter.routerMgr === undefined) {
      const mgr = AppStorage.get<RouterMgr>(KEY_Z_ROUTER)
      if (!ObjectUtil.isEmpty(mgr)) {
        return mgr as RouterMgr
      } else {
        throw new Error('请在EntryAbility调用 ZRouter.init 初始化')
      }
    }
    return ZRouter.routerMgr
  }

  public static registerNavStack(stackName: string = '', pathStack: NavPathStack): void {
    ZRouter.getRouterMgr().registerNavStack(stackName, pathStack)
  }

  public static getNavStack(): NavPathStack {
    return ZRouter.getRouterMgr().getNavStackByName('')
  }

  public static getNavStackByName(stackName: string): NavPathStack {
    return ZRouter.getRouterMgr().getNavStackByName(stackName)
  }

  public static pushByStackName(stackName: string, name: string, param?: ObjectOrNull) {
    ZRouter.getRouterMgr().pushByStackName(stackName, name, param)
  }

  public static push(name: string, param?: ObjectOrNull) {
    ZRouter.getRouterMgr().push(name, param)
  }

  /**
   * 跳转页面，可携带返回数据
   * @see {popWithResult}
   * @param name
   * @param param
   * @param callback
   */
  public static pushForResult(name: string, param?: ObjectOrNull, callback?: OnPopCallback) {
    ZRouter.getRouterMgr().pushForResult(name, param, callback)
  }

  /**
   * 重定向页面，可携带返回数据
   * @param name
   * @param param
   * @param callback
   */
  public static redirectForResult(name: string, param?: ObjectOrNull, callback?: OnPopCallback) {
    ZRouter.getRouterMgr().redirectForResult(name, param, callback)
  }

  public static redirect(name: string) {
    ZRouter.getRouterMgr().redirect(name)
  }


  public static popToName(name: string) {
    ZRouter.getRouterMgr().popToName(name)
  }

  public static pop() {
    ZRouter.getRouterMgr().pop()
  }

  public static popWithResult(result?: Object) {
    ZRouter.getRouterMgr().popWithResult(result)
  }

  public static addGlobalInterceptor(callback: (info: InterceptorInfo) => void) {
    ZRouter.getRouterMgr().addGlobalInterceptor(callback)
  }

  public static addInterceptor(key: string, callback: (info: InterceptorInfo) => void) {
    ZRouter.getRouterMgr().addInterceptor(key, callback)
  }


  public static removeInterceptor(key: string) {
    ZRouter.getRouterMgr().removeInterceptor(key)
  }

  public static clear() {
    ZRouter.getRouterMgr().clear()
  }

  public static getAllPathName(): string[] {
    return ZRouter.getRouterMgr().getAllPathName()
  }

  public static getTopPathName(): string | null {
    return ZRouter.getRouterMgr().getTopPathName()
  }


  public static pushByTopName(remove: boolean = true) {
    ZRouter.getRouterMgr().pushByTopName(remove)
  }
}