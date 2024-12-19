/**
 * @author: HZWei
 * @date: 2024/10/20
 * @desc:
 */
import LogUtil from "../utlis/LogUtil"
import { util } from "@kit.ArkTS"
import { RouterMgr } from "../api/RouterMgr"
import { ZRouter } from "../api/Router"

export class ConfigInitializer implements IConfigOptions {
  private _onDynamicLoadComplete?: () => void
  private _dynamicLoadDelayTime: number = 0
  private _isHSPModuleDependent: boolean = false
  private _isLoadModulesThreadEnabled: boolean = false
  private _isLoggingEnabled: boolean = true
  private _loadDynamicModule: string[] = []
  private _isLoaded = false
  private _onDynamicLoadedComplete?: () => void

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


  constructor() {
    util.Aspect.addAfter(ZRouter, "setup", true, () => {
      this.dynamicImportModule()
    })
  }

  public set onDynamicLoadComplete(value: () => void) {
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

    setTimeout(() => {
      Promise.allSettled(this._loadDynamicModule.map((value) => this.importModule(value)))
        .catch((e: Error) => {
          LogUtil.log(`模块加载异常`)
        })
        .finally(() => {
          this._isLoaded = true
          this._onDynamicLoadComplete?.()
          this._onDynamicLoadedComplete?.()

        })
    }, this._dynamicLoadDelayTime)

  }

  private importModule(module: string): Promise<ESObject> {
    return new Promise<ESObject>((resolve, reject) => {
      import(module).then((ns: ESObject) => {
        if (this._isLoggingEnabled) {
          LogUtil.log(`${module} 模块加载成功`)
        }
        resolve(ns)
      }).catch((err: Error) => {
        if (this._isLoggingEnabled) {
          LogUtil.log(`${module} 模块加载失败: ${err.message}`)
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


