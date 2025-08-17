/**
 * @author: HZWei
 * @date: 2024/10/20
 * @desc:
 */
import { util } from "@kit.ArkTS"
import { ZRouter } from "../api/Router"
import Logger from "../utlis/Logger"
import { ZObject } from "./Model"

type onDynamicLoadedComplete = (path?: string) => void | Promise<ZObject>

export class ConfigInitializer implements IConfigOptions {
  private _onDynamicLoadComplete?: onDynamicLoadedComplete
  private _dynamicLoadDelayTime: number = 0
  private _isHSPModuleDependent: boolean = false
  private _isLoadModulesThreadEnabled: boolean = false
  private _isLoggingEnabled: boolean = true
  private _loadDynamicModule: string[] = []
  private _isLoaded = false
  private _onDynamicLoadedComplete?: onDynamicLoadedComplete
  // private _isMetaServiceHspEnabled: boolean = false

  public get dynamicLoadDelayTime(): number {
    return this._dynamicLoadDelayTime
  }


  public get isLoadModulesThreadEnabled(): boolean {
    return this._isLoadModulesThreadEnabled
  }


  public get isHSPModuleDependent(): boolean {
    return this._isHSPModuleDependent
  }


  public get isLoggingEnabled(): boolean {
    return this._isLoggingEnabled
  }


  public get loadDynamicModule(): string[] {
    return this._loadDynamicModule
  }


  // public get isMetaServiceHspEnabled(): boolean {
  //   return this._isMetaServiceHspEnabled
  // }
  //

  constructor() {
    util.Aspect.addAfter(ZRouter, "setup", true, () => {
      this.dynamicImportModule()
    })
  }

  public set onDynamicLoadComplete(value: onDynamicLoadedComplete) {
    if (!this._onDynamicLoadComplete) {
      this._onDynamicLoadComplete = value
    } else {
      this._onDynamicLoadedComplete = value
    }

  }

  public set dynamicLoadDelayTime(value: number) {
    this._dynamicLoadDelayTime = value
  }

  public set isLoadModulesThreadEnabled(value: boolean) {
    this._isLoadModulesThreadEnabled = value
  }

  public set isHSPModuleDependent(value: boolean) {
    this._isHSPModuleDependent = value
  }

  public set isLoggingEnabled(value: boolean) {
    this._isLoggingEnabled = value
  }

  public set loadDynamicModule(value: string[]) {
    this._loadDynamicModule = value
  }




  private dynamicImportModule() {
    if (this._loadDynamicModule.length == 0 && this._isLoaded) {
      return
    }

    const moduleNames = this._loadDynamicModule.filter((value) => !value.startsWith('.'))
    const filePath = this._loadDynamicModule.find((value) => value.startsWith('.'))

    setTimeout(() => {
      Promise.allSettled(moduleNames.map((value) => this.importModule(value)))
        .catch((e: Error) => {
          Logger.log(`模块加载异常`)
        })
        .finally(() => {
          this._isLoaded = true
          this._onDynamicLoadComplete?.(filePath)
          this._onDynamicLoadedComplete?.(filePath)

        })
    }, this._dynamicLoadDelayTime)

  }

  private importModule(module: string): Promise<ZObject> {
    return new Promise<ZObject>((resolve, reject) => {
      import(module).then((ns: ZObject) => {
        if (this._isLoggingEnabled) {
          Logger.log(`${module} 模块加载成功`)
        }
        resolve(ns)
      }).catch((err: Error) => {
        if (this._isLoggingEnabled) {
          Logger.log(`${module} 模块加载失败: ${err.message}`)
          reject(err)
        }
      })
    })
  }

}

 interface IConfigOptions {
  /**
   * 是否有依赖hsp模块
   */
  isHSPModuleDependent: boolean


  /**
   * 是否开启元服务跨hsp模块跳转
   */
  // isMetaServiceHspEnabled: boolean

  /**
   * 是否打印日志
   */
  isLoggingEnabled: boolean
  /**
   * 指定动态加载的模块名称，用于服务路由自动注册
   * 必须与dependencies的依赖名称保持一致
   */
  loadDynamicModule: string[]
  /**
   * 延迟动态加载的时间，单位毫秒
   */
  dynamicLoadDelayTime: number

  /**
   * 动态加载完成后回调函数
   */
  onDynamicLoadComplete?: () => void

}


