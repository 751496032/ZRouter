/**
 * @author: HZWei
 * @date: 2024/11/25
 * @desc:
 */
import { PreferencesUtil } from "@hzw/common_library";
import { Logger } from "@hzw/logger";
import { AbilityStage } from "@kit.AbilityKit";
import BuildProfile from "BuildProfile";
import { ZObject, ZRouter } from "routerapi";

export class AppAbilityStage extends AbilityStage{
  onCreate(): void {
    // 应用HAP首次加载时触发，可以在此执行该Module的初始化操作（例如资源预加载、线程创建等）。
    // 在module.json5配置文件中，通过配置 srcEntry 参数来指定模块对应的代码路径，以作为HAP加载的入口。

    // 初始化日志
    Logger.init({
      debug: BuildProfile.DEBUG, domain: 0x8888
    })
    // 初始化路由
    ZRouter.initialize((config) => {
      // 强烈建议初始化 context
      config.context = this.context
      // 可选
      config.isGlobalPopCallbackEnabled = true
      config.isLoggingEnabled = true
      config.isHSPModuleDependent = true
      // 路由服务动态加载的模块
      config.loadDynamicModule = ['@hzw/hara', 'harb', 'hspc', '../_generated/ZRService.ets']
      config.onDynamicLoadComplete = (path) => {
        if (path) {
          // entry模块的服务路由动态加载
          import(path).then((module:ESObject) => {
            console.log("Entry ZRService 动态加载成功", module)
            console.log("已完成所有模块的加载")
          })
        }else {
          console.log("已完成所有模块的加载")
        }
      }
    })
    PreferencesUtil.init(this.context)

  }
}