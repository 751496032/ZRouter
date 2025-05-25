import { hspTasks } from '@ohos/hvigor-ohos-plugin';
// import { routerRegisterPlugin, PluginConfig } from 'router-register-plugin'
//
// const config: PluginConfig = {
//     scanDirs: ["src/main/ets/pages", "src/main/ets/service"],
//     logEnabled: true,
//     viewNodeInfo: false
// }
export default {
    system: hspTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins:[/*routerRegisterPlugin(config)*/]         /* Custom plugin to extend the functionality of Hvigor. */
}
