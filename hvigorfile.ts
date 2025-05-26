import { appTasks } from '@ohos/hvigor-ohos-plugin';
import { routerRegisterPlugin, PluginConfig } from 'router-register-plugin'

const config: PluginConfig = {
  scanDirs: ["src/main/ets/components", "src/main/ets/service", "src/main/ets/views", "src/main/ets/pages",
    'src/main/ets/model'],
  logEnabled: true, // 查看日志
  viewNodeInfo: false, // 查看节点信息
  lifecycleObserverAttributeName: 'viewModel', // 生命周期观察者属性名
  ignoredModules:['RouterApi','common'], // 忽略的参与构建的模块，建议设置
  enableUiPreviewBuild: false, // 启用UI预览构建，不建议启动
}

export default {
  system: appTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: [routerRegisterPlugin(config)]         /* Custom plugin to extend the functionality of Hvigor. */
}
