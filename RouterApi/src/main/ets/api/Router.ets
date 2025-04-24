/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjUtil } from '../utlis/ObjUtil'
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
import { NavDestBuilder } from '../model/NavDestBuilder'
import { IInterceptor, IGlobalNavigateInterceptor } from '../interceptions/IInterceptor'
import { ServiceMgr } from '../service/ServiceMgr'
import { IProvider } from '../service/IProvider'
import { ConfigInitializer } from '../model/ConfigInitializer'
import Logger from '../utlis/Logger'
import { NavAnimationMgr } from '../animation/NavAnimationMgr'
import { ILifecycleObserver } from '../lifecycle/ILifecycleObserver'
import { LifecycleObserver } from '../lifecycle/LifecycleEvent'
import { TemplateMgr } from '../template/TemplateMgr'
import { LifecycleMgr } from '../lifecycle/LifecycleMgr'

const KEY_Z_ROUTER = 'ZRouter'

export class ZRouter {
  private static routerMgr: RouterMgr | undefined = undefined



  private constructor() {
  }

  /**
   * 初始化路由
   * @param invoke
   */
  public static initialize(invoke?: ((config: ConfigInitializer) => void)) {
    const config = new ConfigInitializer()
    invoke?.(config)
    LogUtil.config = { isShowLog: config.isLoggingEnabled }
    Logger.isShowLog = config.isLoggingEnabled
    ZRouter.setup(config.isHSPModuleDependent)
    config.onDynamicLoadComplete = () => {
      ZRouter.getRouterMgr().isDynamicLoadedComplete = true
      ZRouter.getRouterMgr().moduleLoadedListener?.()
    }
  }

  public static setModuleLoadedListener(listener: () => void) {
    if (ZRouter.isDynamicLoadedComplete()) {
      listener()
    } else {
      ZRouter.getRouterMgr().moduleLoadedListener = listener
    }
  }


  public static isDynamicLoadedComplete(): boolean {
    return ZRouter.getRouterMgr().isDynamicLoadedComplete
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
      if (!ObjUtil.isEmpty(mgr)) {
        return mgr as RouterMgr
      } else {
         ZRouter.init(true)
      }
    }
    if (!ZRouter.routerMgr) {
      throw new Error('请在AbilityStage或EntryAbility调用 ZRouter.initialize 初始化，建议在AbilityStage完成初始化')
    }
    return ZRouter.routerMgr
  }

  /**
   * 获取路由操作的实例,如跳转、返回等操作
   * @param stackName 栈名，如果有多个Navigation，需要设置，如果一个应用只有一个，可不设置
   * @returns
   */
  public static getInstance(stackName: string = DEFAULT_STACK_NAME): NavDestBuilder<ObjectOrNull> {
    if (ZRouter.routerMgr === undefined) {
      ZRouter.routerMgr = ZRouter.getRouterMgr()
    }
    return NavDestBuilder.create<ObjectOrNull>(ZRouter.routerMgr, stackName)
  }

  /**
   * 获取路由操作的实例,如跳转、返回等操作
   * @param stackName 栈名，如果有多个Navigation，需要设置，如果一个应用只有一个，可不设置
   * @returns
   */
  public static instance<T>(stackName: string = DEFAULT_STACK_NAME): NavDestBuilder<T> {
    if (ZRouter.routerMgr === undefined) {
      ZRouter.routerMgr = ZRouter.getRouterMgr()
    }
    return NavDestBuilder.create<T>(ZRouter.routerMgr, stackName)
  }

  private static serviceMgr(): ServiceMgr {
    return ZRouter.getRouterMgr().serviceMgr()
  }

  /**
   * 添加服务路由，开发者不需要手动调用，在编译阶段会自动生成模版代码
   * @param name
   * @param service
   */
  public static addService(name: string, service: IProvider) {
    ZRouter.serviceMgr().addService(name, service)
  }


  /**
   * 获取服务路由实例
   * @param name
   * @returns
   */
  public static getService<T extends IProvider>(name: string): T | null {
    return ZRouter.serviceMgr().getService<T>(name)
  }

  /**
   * 获取动画管理类
   * @returns
   */
  public static animateMgr(): NavAnimationMgr {
    return ZRouter.getRouterMgr().animateMgr
  }

  /**
   * 注册关联一个路由栈到ZRouter中，通常情况使用不上，一般用于第三方的Navigation的路由栈关联到ZRouter中
   * @param stackName
   * @param pathStack
   */
  public static registerNavStack(stackName: string = DEFAULT_STACK_NAME, pathStack: NavPathStack): void {
    ZRouter.getRouterMgr().registerNavStack(stackName, pathStack)
  }

  /**
   * 从ZRouter解注册路由栈，通常情况使用不上
   * @param stackName
   */
  public static unregisterNavStack(stackName: string) {
    ZRouter.getRouterMgr().unregisterNavStack(stackName)
  }

  /**
   * 获取默认栈名的路由栈，初次调用会创建一个实例，并入参到Navigation构造方法中
   * @param willShow 可选
   * @returns
   */
  public static getNavStack(willShow?: InterceptionShowCallback): NavPathStack {
    return ZRouter.getRouterMgr().getNavStackByName(DEFAULT_STACK_NAME, willShow)
  }

  /**
   * 根据栈名获取路由栈，【初次调用会创建一个实例，并入参到Navigation构造方法中】
   * @param stackName
   * @returns
   */
  public static getNavStackByName(stackName: string): NavPathStack {
    return ZRouter.getRouterMgr().getNavStackByName(stackName)
  }

  /**
   * 获取当前路由栈
   * @returns
   */
  public static getCurrentNavStack(): NavPathStack {
    return ZRouter.getNavStackByName(ZRouter.getCurrentStackName())
  }

  /**
   * 获取当前路由栈的栈顶页面DestinationId
   * @returns
   */
  public static getLastNavDestinationId(): string | undefined {
    return ZRouter.getRouterMgr().getLastNavDestinationId()
  }



  /**
   * 设置全局拦截器，每个路由栈只能设置一次
   * @param interceptor
   * @param stackName
   */
  public static setGlobalInterceptor(interceptor: IGlobalNavigateInterceptor, stackName: string = DEFAULT_STACK_NAME) {
    ZRouter.getRouterMgr().setGlobalInterceptor(interceptor, stackName)
  }

  /**
   * 添加拦截器，可设置多次
   * @param interceptor
   * @param stackName
   */
  public static setInterceptor<T extends IInterceptor>(interceptor: T, stackName: string = DEFAULT_STACK_NAME) {
    ZRouter.getRouterMgr().setInterceptor<T>(interceptor, stackName)
  }


  /**
   * 移除拦截器
   * @param interceptor
   * @param stackName
   * @returns true:移除成功，false:移除失败
   */
  public static removeInterceptor<T extends IInterceptor>(interceptor: T,
    stackName: string = DEFAULT_STACK_NAME): boolean {
    return ZRouter.getRouterMgr().removeInterceptor<T>(interceptor, stackName)
  }

  /**
   * 添加全局的NavDestination页面的生命周期观察者
   * @param observer
   * @returns
   */
  public static addGlobalLifecycleObserver<IL extends ILifecycleObserver>(observer: IL): LifecycleMgr {
    return ZRouter.getRouterMgr().lifecycleMgr.addGlobalObserver(observer)
  }

  /**
   * 添加单个NavDestination页面的生命周期观察者，在NavDestination页面模版模式下才会生效
   * @param observer
   */
  public static addLifecycleObserver(observer: LifecycleObserver): TemplateMgr {
    return TemplateMgr.getInstance().addObserver(observer)
  }

  /**
   * 获取NavDestination页面模板管理器
   * @returns
   */
  public static templateMgr() {
    return TemplateMgr.getInstance()
  }


  /**
   * 获取当前路由栈名称
   * @returns
   */
  public static getCurrentStackName(): string {
    return ZRouter.getRouterMgr().currentStackName
  }


  /**
   * 获取路由参数 建议带上默认值和泛型
   * @param key
   * @param defVal
   * @returns
   */
  public static getParamByKey<P = ObjectOrNull>(key: string, defVal: ObjectOrNull = null): P {
    return ZRouter.getInstance().getParamByKey<P>(key, defVal)
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
  public static popWithResult(result: Object, animated: boolean = true) {
    ZRouter.getRouterMgr().popWithResult(result, animated)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().popNavWithResult}
   * @param name
   * @param result
   * @param animated
   */
  public static popNavWithResult<T>(name: string, result: T, animated: boolean = true) {
    ZRouter.getRouterMgr().popNavWithResult<T>(name, result, animated)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().popToRootWithResult}
   * @param result
   * @param animated
   */
  public static popToRootWithResult<T>(result: T, animated: boolean = true) {
    ZRouter.getRouterMgr().popToRootWithResult<T>(result, animated)
  }

  /**
   * @deprecated
   * @see {ZRouter.getInstance().finishWithResult}
   * @param result
   * @param animated
   */
  public static finishWithResult<T>(result: T, animated: boolean = true) {
    return ZRouter.getRouterMgr().finishWithResult<T>(result, animated)
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