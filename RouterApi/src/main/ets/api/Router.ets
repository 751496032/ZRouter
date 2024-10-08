/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjectUtil } from '../utlis/ObjectUtil'
import {
  DEFAULT_STACK_NAME,
  InitConfig,
  InterceptorInfo,
  ObjectOrNull,
  OnPopCallback,
  OnPopResultCallback
} from '../model/Model'
import { RouterMgr } from './RouterMgr'
import LogUtil from '../utlis/LogUtil'
import { NavBuilder } from '../model/NavBuilder'
import { IInterceptor, IGlobalNavigateInterceptor } from '../interceptions/IInterceptor'

const KEY_Z_ROUTER = 'ZRouter'

export class ZRouter {
  private static routerMgr: RouterMgr | undefined = undefined

  private constructor() {
  }

  public static init(isDependHspModule: boolean = false, config: InitConfig = { isShowLog: true }) {
    ZRouter.routerMgr = RouterMgr.getInstance()
    if (isDependHspModule) {
      AppStorage.setOrCreate(KEY_Z_ROUTER, ZRouter.routerMgr)
    }
    LogUtil.config = config
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

  public static registerNavStack(stackName: string = DEFAULT_STACK_NAME, pathStack: NavPathStack): void {
    ZRouter.getRouterMgr().registerNavStack(stackName, pathStack)
  }

  public static unregisterNavStack(stackName: string) {
    ZRouter.getRouterMgr().unregisterNavStack(stackName)
  }

  public static getNavStack(willShow?: InterceptionShowCallback): NavPathStack {
    return ZRouter.getRouterMgr().getNavStackByName(DEFAULT_STACK_NAME, willShow)
  }

  public static getNavStackByName(stackName: string): NavPathStack {
    return ZRouter.getRouterMgr().getNavStackByName(stackName)
  }


  public static push(name: string, param?: ObjectOrNull, animated: boolean = true) {
    ZRouter.getRouterMgr().push<ObjectOrNull>(name, param, animated)
  }


  public static pushForResult(name: string, param?: ObjectOrNull, callback?: OnPopCallback) {
    ZRouter.getRouterMgr().pushForResult<ObjectOrNull>(name, param, callback)
  }


  public static pushNavForResult<T>(name: string, param?: ObjectOrNull, callback?: OnPopResultCallback<T>) {
    ZRouter.getRouterMgr().pushNavForResult<T>(name, param, callback)
  }


  public static redirectForResult2<T>(name: string, param?: ObjectOrNull, callback?: OnPopResultCallback<T>) {
    ZRouter.getRouterMgr().redirectForResult2(name, param, callback)
  }

  public static redirect(name: string) {
    ZRouter.getRouterMgr().redirect<ObjectOrNull>(name)
  }


  public static popToName(name: string, animated: boolean = true) {
    ZRouter.getRouterMgr().popToName(name, animated)
  }

  public static pop(animated: boolean = true) {
    ZRouter.getRouterMgr().pop(animated)
  }

  public static popWithResult(result?: Object, animated: boolean = true) {
    ZRouter.getRouterMgr().popWithResult(result, animated)
  }

  public static popNavWithResult<T>(name: string, result?: T, animated: boolean = true) {
    ZRouter.getRouterMgr().popNavWithResult<T>(name, result, animated)
  }

  public static popToRootWithResult<T>(result?: T, animated: boolean = true) {
    ZRouter.getRouterMgr().popToRootWithResult<T>(result, animated)
  }

  public static finishWithResult<T>(result?: T, animated: boolean = true) {
    ZRouter.getRouterMgr().finishWithResult<T>(result, animated)
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


  public static getParamByName(name: string): Record<string, ObjectOrNull>[] {
    return ZRouter.getRouterMgr().getParamByName(name)
  }

  public static getParam(): ObjectOrNull {
    return ZRouter.getRouterMgr().getParam()
  }

  public static getAnnotationParam() {
    return ZRouter.getRouterMgr().getAnnotationParam()
  }

  public static removeByName(name: string) {
    ZRouter.getRouterMgr().removeByName(name)
  }

  public static moveToTop(name: string) {
    ZRouter.getRouterMgr().moveToTop(name)
  }

  public static replacePathByName(name: string, param?: ObjectOrNull, animated: boolean = true) {
    ZRouter.getRouterMgr().replacePathByName<ObjectOrNull>(name, param, animated)
  }

  public static getInstance(stackName: string = DEFAULT_STACK_NAME): NavBuilder<ObjectOrNull> {
    if (ZRouter.routerMgr === undefined) {
      ZRouter.routerMgr = ZRouter.getRouterMgr()
    }
    return NavBuilder.create<ObjectOrNull>(ZRouter.routerMgr, stackName)
  }

  public static instance<T>(stackName: string = DEFAULT_STACK_NAME): NavBuilder<T> {
    if (ZRouter.routerMgr === undefined) {
      ZRouter.routerMgr = ZRouter.getRouterMgr()
    }
    return NavBuilder.create<T>(ZRouter.routerMgr, stackName)
  }


  public static setInterceptor<T extends IInterceptor>(interceptor: T, stackName: string = DEFAULT_STACK_NAME) {
    ZRouter.getRouterMgr().setInterceptor<T>(interceptor, stackName)
  }

  public static getCurrentStackName(): string {
    return ZRouter.getRouterMgr().currentStackName
  }


  // region 废弃方法

  /**
   * @deprecated
   * @param stackName
   * @param name
   * @param param
   * @param animated
   */
  public static pushByStackName(stackName: string, name: string, param?: ObjectOrNull,
    animated: boolean = true) {
    ZRouter.getRouterMgr().pushByStackName(stackName, name, param, animated)
  }


  /**
   * @deprecated
   * @see {redirectForResult2}
   * @param name
   * @param param
   * @param callback
   */
  public static redirectForResult(name: string, param?: ObjectOrNull, callback?: OnPopCallback) {
    ZRouter.getRouterMgr().redirectForResult(name, param, callback)
  }


  public static setGlobalInterceptor(interceptor: IGlobalNavigateInterceptor, stackName: string = DEFAULT_STACK_NAME) {
    ZRouter.getRouterMgr().setGlobalInterceptor(interceptor, stackName)
  }


  /**
   * @deprecated
   * @see {setGlobalInterceptor}
   * @param callback
   */
  public static addGlobalInterceptor(callback: (info: InterceptorInfo) => void) {
    ZRouter.getRouterMgr().addGlobalInterceptor(callback)
  }


  /**
   * @deprecated
   * @see {setInterceptor}
   * @param key
   * @param callback
   */
  public static addInterceptor(key: string, callback: (info: InterceptorInfo) => void) {
    ZRouter.getRouterMgr().addInterceptor(key, callback)
  }

  /**
   * @deprecated
   * @param key
   */
  public static removeInterceptor(key: string) {
    ZRouter.getRouterMgr().removeInterceptor(key)
  }


  /**
   * @deprecated
   * @param remove
   */
  public static pushByTopName(remove: boolean = true) {
    ZRouter.getRouterMgr().pushByTopName(remove)
  }

  // endregion


}