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
import { ServiceMgr } from '../service/ServiceMgr'
import { IProvider } from '../service/IProvider'
import { ConfigInitializer } from '../model/ConfigInitializer'
import Logger from '../utlis/Logger'
import { NavAnimationMgr } from '../animation/NavAnimationMgr'
import { ILifecycleObserver } from '../lifecycle/ILifecycleObserver'
import { LifecycleObserver } from '../lifecycle/LifecycleEvent'
import { templateMgr } from '../lifecycle/template/TemplateMgr'

const KEY_Z_ROUTER = 'ZRouter'

export class ZRouter {
  private static routerMgr: RouterMgr | undefined = undefined

  private constructor() {
  }

  public static initialize(invoke?: ((config: ConfigInitializer) => void)) {
    const config = new ConfigInitializer()
    invoke?.(config)
    LogUtil.config = { isShowLog: config.isLoggingEnabled }
    Logger.isShowLog = config.isLoggingEnabled
    ZRouter.setup(config.isHSPModuleDependent)
  }

  /**
   * @deprecated
   * @see ZRouter.initialize
   * @param isDependHspModule
   * @param config
   */
  public static init(isDependHspModule: boolean = false, config: InitConfig = { isShowLog: true }) {
    LogUtil.config = config
    Logger.isShowLog = config.isShowLog
    ZRouter.setup(isDependHspModule)
  }

  private static setup(isHSPModuleDependent: boolean) {
    ZRouter.routerMgr = RouterMgr.getInstance()
    if (isHSPModuleDependent) {
      LogUtil.log("isHSPModuleDependent ")
      AppStorage.setOrCreate(KEY_Z_ROUTER, ZRouter.routerMgr)
    }
  }

  private static getRouterMgr(): RouterMgr {
    if (ZRouter.routerMgr === undefined) {
      const mgr = AppStorage.get<RouterMgr>(KEY_Z_ROUTER)
      if (!ObjectUtil.isEmpty(mgr)) {
        return mgr as RouterMgr
      } else {
         ZRouter.init(true)
      }
    }
    if (!ZRouter.routerMgr) {
      throw new Error('请在AbilityStage或EntryAbility调用 ZRouter.initialize 初始化')
    }
    return ZRouter.routerMgr
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

  private static getServiceMgr(): ServiceMgr {
    return ZRouter.getRouterMgr().getServiceMgr()
  }

  public static addService(name: string, service: IProvider) {
    ZRouter.getServiceMgr().addService(name, service)
  }


  public static getService<T extends IProvider>(name: string): T | null {
    return ZRouter.getServiceMgr().getService<T>(name)
  }

  public static animateMgr(): NavAnimationMgr {
    return ZRouter.getRouterMgr().animateMgr
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

  public static getCurrentNavStack(): NavPathStack {
    return ZRouter.getNavStackByName(ZRouter.getCurrentStackName())
  }

  public static getLastNavDestinationId(): string | undefined {
    return ZRouter.getRouterMgr().getLastNavDestinationId()
  }




  public static setGlobalInterceptor(interceptor: IGlobalNavigateInterceptor, stackName: string = DEFAULT_STACK_NAME) {
    ZRouter.getRouterMgr().setGlobalInterceptor(interceptor, stackName)
  }

  public static setInterceptor<T extends IInterceptor>(interceptor: T, stackName: string = DEFAULT_STACK_NAME) {
    ZRouter.getRouterMgr().setInterceptor<T>(interceptor, stackName)
  }

  /**
   * 添加全局的NavDestination页面的生命周期观察者
   * @param observer
   * @returns
   */
  public static  addGlobalLifecycleObserver<IL extends ILifecycleObserver>(observer: IL) {
    ZRouter.getRouterMgr().lifecycleMgr.addGlobalObserver(observer)
  }

  /**
   * 添加NavDestination页面的生命周期观察者，在NavDestination页面模版模式下才会生效
   * @param observer
   */
  public static addLifecycleObserver(observer: LifecycleObserver) {
    templateMgr.addObserver(observer)
  }

  public static templateMgr() {
    return templateMgr
  }


  public static getCurrentStackName(): string {
    return ZRouter.getRouterMgr().currentStackName
  }





  // region 废弃方法

  /**
   * @deprecated
   * @see {ZRouter.getInstance().push}
   * @param name
   * @param param
   * @param animated
   */
  public static push(name: string, param?: ObjectOrNull, animated: boolean = true) {
    ZRouter.getRouterMgr().push<ObjectOrNull>(name, param, animated)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().push}
   * @param name
   * @param param
   * @param callback
   */
  public static pushForResult(name: string, param?: ObjectOrNull, callback?: OnPopCallback) {
    ZRouter.getRouterMgr().pushForResult<ObjectOrNull>(name, param, callback)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().push}
   * @param name
   * @param param
   * @param callback
   */
  public static pushNavForResult<T>(name: string, param?: ObjectOrNull, callback?: OnPopResultCallback<T>) {
    ZRouter.getRouterMgr().pushNavForResult<T>(name, param, callback)
  }


  /**
   * @deprecated
   * @see {ZRouter.getInstance().redirectForResult2}
   * @param name
   * @param param
   * @param callback
   */
  public static redirectForResult2<T>(name: string, param?: ObjectOrNull, callback?: OnPopResultCallback<T>) {
    ZRouter.getRouterMgr().redirectForResult2(name, param, callback)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().redirect}
   * @param name
   */
  public static redirect(name: string) {
    ZRouter.getRouterMgr().redirect<ObjectOrNull>(name)
  }


  /**
   * @deprecated
   * @see {ZRouter.getInstance().popToName}
   * @param name
   * @param animated
   */
  public static popToName(name: string, animated: boolean = true) {
    ZRouter.getRouterMgr().popToName(name, animated)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().pop}
   * @param animated
   */
  public static pop(animated: boolean = true) {
    ZRouter.getRouterMgr().pop(animated)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().popWithResult}
   * @param result
   * @param animated
   */
  public static popWithResult(result?: Object, animated: boolean = true) {
    ZRouter.getRouterMgr().popWithResult(result, animated)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().popNavWithResult}
   * @param name
   * @param result
   * @param animated
   */
  public static popNavWithResult<T>(name: string, result?: T, animated: boolean = true) {
    ZRouter.getRouterMgr().popNavWithResult<T>(name, result, animated)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().popToRootWithResult}
   * @param result
   * @param animated
   */
  public static popToRootWithResult<T>(result?: T, animated: boolean = true) {
    ZRouter.getRouterMgr().popToRootWithResult<T>(result, animated)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().finishWithResult}
   * @param result
   * @param animated
   */
  public static finishWithResult<T>(result?: T, animated: boolean = true) {
    ZRouter.getRouterMgr().finishWithResult<T>(result, animated)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().clear}
   */
  public static clear() {
    ZRouter.getRouterMgr().clear()
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().getAllPathName}
   * @returns
   */
  public static getAllPathName(): string[] {
    return ZRouter.getRouterMgr().getAllPathName()
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().getTopPathName}
   * @returns
   */
  public static getTopPathName(): string | null {
    return ZRouter.getRouterMgr().getTopPathName()
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().getParamByName}
   * @param name
   * @returns
   */
  public static getParamByName(name: string): Record<string, ObjectOrNull>[] {
    return ZRouter.getRouterMgr().getParamByName(name)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().getParam}
   * @returns
   */
  public static getParam(): ObjectOrNull {
    return ZRouter.getRouterMgr().getParam()
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().getAnnotationParam}
   * @returns
   */
  public static getAnnotationParam() {
    return ZRouter.getRouterMgr().getAnnotationParam()
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().removeByName}
   * @param name
   */
  public static removeByName(name: string) {
    ZRouter.getRouterMgr().removeByName(name)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().moveToTop}
   * @param name
   */
  public static moveToTop(name: string) {
    ZRouter.getRouterMgr().moveToTop(name)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().replacePathByName}
   * @param name
   * @param param
   * @param animated
   */
  public static replacePathByName(name: string, param?: ObjectOrNull, animated: boolean = true) {
    ZRouter.getRouterMgr().replacePathByName<ObjectOrNull>(name, param, animated)
  }



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


  /**
   * @deprecated
   * @param remove
   */
  public static pushByTopName(remove: boolean = true) {
    ZRouter.getRouterMgr().pushByTopName(remove)
  }

  // endregion


}