/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjectUtil } from '../utlis/ObjectUtil'
import { HashMap } from '@kit.ArkTS'
import { INavDestOptions } from './NavDestOptions'
import { runCatching } from '../utlis/runCatching'

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


  /**
   * 跳转时的配置信息
   */
  navigationOptions?: INavDestOptions<ObjectOrNull>

  private isBefore: boolean = false

  private constructor(notRegistered : boolean = false, isBefore: boolean = false) {
    this.isNotRegistered = notRegistered
    this.isBefore = isBefore
  }

  static create(notRegistered: boolean = false, isBefore: boolean = false) {
    return new InterceptorInfo(notRegistered, isBefore)
  }

  public get isNeedLogin(): boolean {
    return !ObjectUtil.isEmpty(this.metadata) && this.metadata?.needLogin === 'true'
  }

  public get notRegistered(): boolean {
    if (this.isBefore) {
      return this.isNotRegistered
    }
    return !this.isContext() || this.isNotRegistered
  }

  private isContext() {
    return ObjectUtil.isNotEmpty(this.toContext?.pathStack)
      && ObjectUtil.isNotEmpty(this.toContext?.pathInfo)
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
  /**
   * 是一个base64编码的字符串，自行解码获取参数
   */
  others?: string;
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
  /**
   * 页面跳转时的配置信息
   */
  navigationOptions?: INavDestOptions<ObjectOrNull>

  /**
   * @Route和@ZRoute注解上的元数据 - 参数
   */
  metadata?: RouteMetadata
  /**
   * 页面是否未注册
   */
  notRegistered: boolean = false

  private constructor() {
  }
  static create(info : InterceptorInfo) {
    const dest = new DestinationInfo()
    dest.name = info.name
    dest.param = info.param
    dest.operation = info.operation
    dest.action = NavigationAction.NEXT
    dest.metadata = info.metadata
    dest.notRegistered = info.notRegistered
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

export interface IPopOptions {
  // 返回重定向前的页面, 前提调用是使用 redirect()方法
  returnToRedirectedPage?: boolean
  // 以下参数只有在popTo 、 popToRoot、popWithResult方法中才有效
  animated?: boolean
  toRoot?: boolean
  name?: string
  result?: Object
}

export type OnPopCallback = (data: PopInfo) => void | boolean

export type OnPopResultCallback<T> = (data: PopResult<T | ObjectOrNull>) => void | boolean

/**
 * @deprecated
 */
export type OnInterceptorCallback = (data: InterceptorInfo) => void | boolean

export type ObjectOrNull = Object | undefined | null

export type StringOrNull = string | null | undefined

export const NavRootEvent = 'NavRoot'

export const DEFAULT_STACK_NAME = 'ZRouter'

export type  InterceptorInfoOrNull = InterceptorInfo | null | undefined

export type OnAtBottomBackCallback = () => boolean

export type ZObject = ESObject
