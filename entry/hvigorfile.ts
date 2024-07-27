import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { routerRegisterPlugin, PluginConfig } from 'router-register-plugin'
const config: PluginConfig = {
    scanDir: "src/main/ets/pages",
    logEnabled: false,
    viewNodeInfo: false,
}
export default {
    system: hapTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins:[routerRegisterPlugin(config)]         /* Custom plugin to extend the functionality of Hvigor. */
}
