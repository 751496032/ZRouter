/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */

export class InterceptorInfo {
  fromContext: NavDestinationContext
  toContext: NavDestinationContext
  data?: RouteMapData
  private _needLogin: boolean = false

  public get needLogin(): boolean {
    return this.data != undefined && this.data != null && Boolean(this.data.needLogin)
  }

  constructor(fromContext: NavDestinationContext, toContext: NavDestinationContext) {
    this.fromContext = fromContext
    this.toContext = toContext
  }



}

export class RouteMapData {
  name: string = ''
  description?: string
  extra?: string
  needLogin: string = 'false'
}