/**
 * @author: HZWei
 * @date: 2024/10/20
 * @desc:
 */
import { taskpool, util } from "@kit.ArkTS"
import { ZRouter } from "../api/Router"
import Logger from "../utlis/Logger"
import { runCatching } from "../utlis/runCatching"
import { ZObject } from "./Model"
import { RouterMap, RouterMapGenerator } from "./RouterMap"
import { process } from '@kit.ArkTS'
import { KEY_ROUTER_MAP } from "./Const"

type onDynamicLoadedComplete = (path?: string) => void | Promise<ZObject>

export class ConfigInitializer implements IConfigOptions {
  private isRouterMapLoaded: boolean = false
  private _onDynamicLoadComplete?: onDynamicLoadedComplete
  private _dynamicLoadDelayTime: number = 0
  private _isHSPModuleDependent: boolean = false
  private _isLoadModulesThreadEnabled: boolean = false
  private _isLoggingEnabled: boolean = true
  private _loadDynamicModule: string[] = []
  private _isLoaded = false
  private _onDynamicLoadedComplete?: onDynamicLoadedComplete
  private _isRoutePreloadEnabled: boolean = true
  private _context?: Context
  private _isRoutePreloadThreadEnabled: boolean = true


  constructor() {
    util.Aspect.addAfter(ZRouter, "setup", true, () => {
      if (this.isRoutePreloadEnabled) {
        this.loadRouterMap()
      }
      this.dynamicImportModule()
    })
    util.Aspect.addBefore(ZRouter, 'getNavStack', true, () => {
      // 如果尚未加载路由表，会再次尝试加载
      if (!this.isRouterMapLoaded) {
        this.loadRouterMap()
      }

    })
  }

 public get isRoutePreloadThreadEnabled(): boolean {
    return this._isRoutePreloadThreadEnabled
  }

  /**
   * 路由预加载是否启用多线程，默认为true
   * @param value
   */
  public set isRoutePreloadThreadEnabled(value: boolean) {
    this._isRoutePreloadThreadEnabled = value
  }
  /**
   * 强烈建议初始化
   * @param value
   */
  public set context(value: Context) {
    this._context = value
  }

  public get context(): Context {
    return this._context ?? getContext()
  }

  public get isRoutePreloadEnabled(): boolean {
    return this._isRoutePreloadEnabled
  }

  /**
   * 是否启用路由预加载, 默认为true
   * @param value
   */
  public set isRoutePreloadEnabled(value: boolean) {
    this._isRoutePreloadEnabled = value
  }

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




  private async loadRouterMap() {
    Logger.log(`loadRouterMap: 开始加载路由表`, this.isRoutePreloadThreadEnabled)
    if (this.isRoutePreloadThreadEnabled) {
      Logger.log(`isMainThread: ` , process.pid == process.tid)
      taskpool.execute(loadRouterMapFromRawFile, this.context).then((data: object) => {
        this.parseRouterMap(data)
      }).catch((e: Error) => {
        Logger.log(`路由表加载失败: ${e.message}`)
      })
    } else {
      runCatching(async () => {
        await loadRouterMapFromRawFile(this.context).then((data: object) => {
          this.parseRouterMap(data)
        })
      }).onFailure((e: Error) => {
        Logger.log(`路由表加载失败: ${e.message}`)
      })
    }
  }



  private parseRouterMap(data: object) {
    let routerMapGenerator: RouterMapGenerator = data as RouterMapGenerator
    Logger.log(`路由表加载成功` , JSON.stringify(routerMapGenerator))
    this.isRouterMapLoaded = true
    AppStorage.setOrCreate<RouterMap[]>(KEY_ROUTER_MAP, routerMapGenerator.routerMap)

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


@Concurrent
async function loadRouterMapFromRawFile(context: Context): Promise<RouterMapGenerator> {
  Logger.log(`isMainThread: ` , process.pid == process.tid)
  const data = await context.resourceManager.getRawFileContent("router_map.json")
  let textDecoder: util.TextDecoder = new util.TextDecoder();
  let rawfileContent: string = textDecoder.decodeToString(data);
  let routerMapGenerator: RouterMapGenerator = JSON.parse(rawfileContent)

  return routerMapGenerator
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

  /**
   * 是否启用路由预加载, 默认为true
   */
  isRoutePreloadEnabled?: boolean
  /**
   * 上下文，建议初始化时设置
   */
  context: Context

   /**
   * 路由预加载是否启用多线程，默认为true
   */
  isRoutePreloadThreadEnabled?: boolean

}


