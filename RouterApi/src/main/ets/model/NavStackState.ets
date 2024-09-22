/**
 * @author: HZWei
 * @date: 2024/9/18
 * @desc:
 */

import { InterceptorInfo, OnInterceptorCallback } from './Model'
import { RedirectInfo } from './RedirectModel'

export default  class NavStackState {
  // private _interceptions: Map<string, OnInterceptorCallback> = new Map<string, OnInterceptorCallback>()
  private _stackTopInfo: InterceptorInfo | undefined
  private _redirectWithResultMode: boolean = false
  private _redirectInfo = new RedirectInfo()
  private _stackName: string = ''

  private constructor(name: string) {
    this._stackName = name
  }

  public static create(name: string): NavStackState {
    return new NavStackState(name)
  }

  public get stackName(): string {
    return this._stackName
  }


  // public set interceptions(value: Map<string, OnInterceptorCallback>) {
  //   this._interceptions = value
  // }
  //
  // public get interceptions(): Map<string, OnInterceptorCallback> {
  //   return this._interceptions
  // }

  public set stackTopInfo(value: InterceptorInfo | undefined) {
    this._stackTopInfo = value
  }

  public get stackTopInfo(): InterceptorInfo | undefined {
    return this._stackTopInfo
  }

  public set redirectWithResultMode(value: boolean) {
    this._redirectWithResultMode = value
  }

  public get redirectWithResultMode(): boolean {
    return this._redirectWithResultMode
  }


  public set redirectInfo(value) {
    this._redirectInfo = value
  }

  public get redirectInfo() {
    return this._redirectInfo
  }



}