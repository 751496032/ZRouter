/**
 * @author: HZWei
 * @date: 2024/9/18
 * @desc: 页面跳转的状态信息
 */

import Logger from '../utlis/Logger'
import { InterceptorInfo, ObjectOrNull } from './Model'
import { NavDestBuilder } from './NavDestBuilder'
import { INavDestOptions } from './NavDestOptions'
import { RedirectInfo } from './RedirectModel'
import { BusinessError } from '@ohos.base'

export default class NavDestState {
  private _stackTopInfo: InterceptorInfo | undefined
  private _redirectWithResultMode: boolean = false
  private _redirectInfo = new RedirectInfo()
  private _stackName: string = ''
  private _destOptionsMap: Map<string, INavDestOptions<ObjectOrNull>> = new Map<string, INavDestOptions<ObjectOrNull>>()

  private constructor(name: string) {
    this._stackName = name
  }

  public static create(name: string): NavDestState {
    return new NavDestState(name)
  }

  public getDestOptions(name: string): INavDestOptions<ObjectOrNull> | undefined {
    const key = this.findDestOptionsKey(name)
    return key ? this._destOptionsMap.get(key) : undefined
  }


  private findDestOptionsKey(name: string): string | undefined {
    const keys = Array.from(this._destOptionsMap.keys()).reverse()
    for (const key of keys) {
      if (key.startsWith(name)) {
        return key
      }
    }
    return undefined
  }

  public deleteDestOptions(name: string) {
    try {
      const key = this.findDestOptionsKey(name)
      if (key) {
        this._destOptionsMap.delete(key)
      }
    } catch (e) {
      Logger.error((e as Error).message)
    }

  }

  public setDestOptions(name: string, builder: INavDestOptions<ObjectOrNull>) {
    if (this._destOptionsMap.has(name)) {
      name = name + '_' + Date.now()
    }
    this._destOptionsMap.set(name, builder)
  }

  public get stackName(): string {
    return this._stackName
  }

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