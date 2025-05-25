import { hapTasks } from '@ohos/hvigor-ohos-plugin';
// import { routerRegisterPlugin, PluginConfig } from 'router-register-plugin'
export default {
    system: hapTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins:[/*routerRegisterPlugin({})*/]         /* Custom plugin to extend the functionality of Hvigor. */
}
