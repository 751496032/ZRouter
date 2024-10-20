/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjectUtil } from '../utlis/ObjectUtil'
import { HashMap } from '@kit.ArkTS'

export class InterceptorInfo {
  private isNotRegistered: boolean = false
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
  metadata?: RouteMetadata
  param?: ObjectOrNull // 跳转携带的参数
  name: string = '' // 跳转页面名称
  // isInterruptGlobalInterceptor = false // 是否中断全局拦截器 在单个拦截器中使用



  private constructor(notRegistered : boolean = false) {
    this.isNotRegistered = notRegistered
  }

  static create(notRegistered : boolean = false) {
    return new InterceptorInfo(notRegistered)
  }

  public get isNeedLogin(): boolean {
    return !ObjectUtil.isEmpty(this.metadata) && this.metadata?.needLogin === 'true'
  }

  public get notRegistered(): boolean {
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
}

/**
 * @deprecated
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

export const DEFAULT_STACK_NAME = ''

export type  InterceptorInfoOrNull = InterceptorInfo | null