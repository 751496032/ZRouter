/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { ObjectUtil } from '../utlis/ObjectUtil'

export class InterceptorInfo {
  toContext: NavDestinationContext | undefined
  data?: RouteMapData
  // private _needLogin: boolean = false


  public get needLogin(): boolean {
    return !ObjectUtil.isEmpty(this.data) && this.data?.needLogin === 'true'
  }

  public get notRegistered(): boolean {
    return !this.isContext()
  }

  private isContext() {
    return ObjectUtil.isNotEmpty(this.toContext?.pathStack)
      && ObjectUtil.isNotEmpty(this.toContext?.pathInfo)
  }

}


export class RouteMapData {
  name: string = ''
  description?: string
  extra?: string
  needLogin: string = 'false'
}


export type OnPopCallback = (data: PopInfo) => void | boolean

export type OnInterceptorCallback = (data: InterceptorInfo) => void | boolean

export type ObjectOrNull = Object | undefined | null