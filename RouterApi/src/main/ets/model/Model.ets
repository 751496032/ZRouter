/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import BuildProfile from '../../../../BuildProfile'
import LogUtil from '../utlis/LogUtil'
import { ObjectUtil } from '../utlis/ObjectUtil'

export class InterceptorInfo {
  toContext: NavDestinationContext | undefined
  metadata?: RouteMetadata


  public get isNeedLogin(): boolean {
    return !ObjectUtil.isEmpty(this.metadata) && this.metadata?.needLogin === 'true'
  }

  public get notRegistered(): boolean {
    return !this.isContext()
  }

  private isContext() {
    return ObjectUtil.isNotEmpty(this.toContext?.pathStack)
      && ObjectUtil.isNotEmpty(this.toContext?.pathInfo)
  }

}


export class RouteMetadata {
  name: string = ''
  description?: string
  extra?: string
  needLogin: string = ''
}


export class InitConfig {
  isShowLog: boolean = true
}

export class PopResult<T> {
  data?: T;
  from?: string
}

export type OnPopCallback = (data: PopInfo) => void | boolean

export type OnPopResultCallback<T> = (data: PopResult<T>) => void | boolean

export type OnInterceptorCallback = (data: InterceptorInfo) => void | boolean

export type ObjectOrNull = Object | undefined | null

export const NavRootEvent = 'NavRoot'