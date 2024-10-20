/**
 * @author: HZWei
 * @date: 2024/10/20
 * @desc:
 */

export class ConfigInitializer implements  IConfigOptions{
  private _isHSPModuleDependent: boolean = false
  private _isLoggingEnabled: boolean = false
  private _loadDynamicModule: string[] = []

  public get isHSPModuleDependent(): boolean {
    return this._isHSPModuleDependent
  }

  public get isLoggingEnabled(): boolean {
    return this._isLoggingEnabled
  }


  public get loadDynamicModule(): string[] {
    return this._loadDynamicModule
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

}

export  interface IConfigOptions {
  /**
   * 是否有依赖hsp模块
   */
  isHSPModuleDependent: boolean
  /**
   * 是否打印日志
   */
  isLoggingEnabled: boolean
  /**
   * 指定动态加载的模块，服务路由需要用上
   */
  loadDynamicModule: string[]
}


