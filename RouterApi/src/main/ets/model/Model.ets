/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjUtil } from '../utlis/ObjUtil'
import { HashMap } from '@kit.ArkTS'

export class InterceptorInfo {
  /**
   * 页面是否注册
   */
  private isNotRegistered: boolean = false
  /**
   * 拦截器携带的额外数据 预留
   * 目前暂时没有作用
   */
  private extra = new HashMap<string, ObjectOrNull>()
  /**
   * 页面在没有注册的情况下，以下属性不可使用
   * @field toContext
   * @field metadata
   * @function isNeedLogin
   * 外部可以通过{notRegistered}方法判断页面是否注册
   * @function notRegistered
   */
  toContext: NavDestinationContext | undefined
  /**
   * @Route和@ZRoute注解上的元数据 - 参数
   */
  metadata?: RouteMetadata
  /**
   * 跳转携带的参数
   */
  param?: ObjectOrNull
  /**
   * 页面跳转的name
   * 对应RouteMetadata中的name
   */
  name: string = ''

  /**
   * 页面跳转的操作类型
   */
  operation?: NavigationOperation




  private constructor(notRegistered : boolean = false) {
    this.isNotRegistered = notRegistered
  }

  static create(notRegistered : boolean = false) {
    return new InterceptorInfo(notRegistered)
  }

  public get isNeedLogin(): boolean {
    return !ObjUtil.isEmpty(this.metadata) && this.metadata?.needLogin === 'true'
  }

  public get notRegistered(): boolean {
    return !this.isContext() || this.isNotRegistered
  }

  private isContext() {
    return ObjUtil.isNotEmpty(this.toContext?.pathStack)
      && ObjUtil.isNotEmpty(this.toContext?.pathInfo)
  }

  public putExtra(key: string, value: ObjectOrNull) {
    this.extra.set(key, value)
  }

  public getExtra(key: string) {
    return this.extra.get(key)
  }



}


export class RouteMetadata {
  name: string = ''
  description?: string
  extra?: string
  needLogin: string = ''
}


export class DestinationInfo {
  /**
   * 跳转携带的参数
   */
  param?: ObjectOrNull
  /**
   * 页面跳转的name
   * 对应RouteMetadata中的name
   */
  name: string = ''

  /**
   * 页面跳转的操作类型
   */
  operation?: NavigationOperation

  /**
   *  是否拦截、继续
   */
  action: NavigationAction = NavigationAction.NEXT

  private constructor() {
  }
  static create(info : InterceptorInfo) {
    const dest = new DestinationInfo()
    dest.name = info.name
    dest.param = info.param
    dest.operation = info.operation
    dest.action = NavigationAction.NEXT
    return dest
  }
  isContinue() {
    return this.action === NavigationAction.NEXT
  }
  next() {
    this.action = NavigationAction.NEXT
  }
  block() {
    this.action = NavigationAction.BLOCK
  }
}


export enum NavigationAction {
  NEXT = 'next', // 继续
  BLOCK = 'block', // 拦截
}

/**
 *
 * @class ConfigInitializer
 */
export class InitConfig {
  isShowLog: boolean = true
}

export class PopResult<T> {
  data?: T;
  from?: string
}

export type OnPopCallback = (data: PopInfo) => void | boolean

export type OnPopResultCallback<T> = (data: PopResult<T | ObjectOrNull>) => void | boolean

/**
 * @deprecated
 */
export type OnInterceptorCallback = (data: InterceptorInfo) => void | boolean

export type ObjectOrNull = Object | undefined | null

export const NavRootEvent = 'NavRoot'

export const DEFAULT_STACK_NAME = 'ZRouter'

export type  InterceptorInfoOrNull = InterceptorInfo | null | undefined