import { Logger } from "@hzw/logger";
import { AbilityStage, Want } from "@kit.AbilityKit";
import BuildProfile from "BuildProfile";
import { ZRouter } from "routerapi";

/**
 * @author: HZWei
 * @date: 2024/11/22
 * @desc:
 *  在module.json5配置文件中，通过配置 srcEntry 参数来指定模块对应的代码路径，以作为HAP加载的入口
 */
export class AppAbilityStage extends AbilityStage {
  onCreate(): void {
    // 应用HAP首次加载时触发，可以在此执行该Module的初始化操作（例如资源预加载、线程创建等）。
    Logger.init({
      debug: BuildProfile.DEBUG, domain: 0x8888
    })
    ZRouter.initialize((config) => {
      config.isLoggingEnabled = BuildProfile.DEBUG
      config.isHSPModuleDependent = true
      config.loadDynamicModule = ['@hzw/hara', 'harb', 'hspc']
      config.onDynamicLoadComplete = () => {
        console.log("已完成所有模块的加载")
      }
    })
  }
}