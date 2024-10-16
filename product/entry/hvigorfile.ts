import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { routerRegisterPlugin, PluginConfig } from 'router-register-plugin'
const config: PluginConfig = {
    scanDirs: ['src/main/ets/pages', 'src/main/ets/views'],
    logEnabled: true,
    viewNodeInfo: false,

}
export default {
    system: hapTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins:[routerRegisterPlugin(config)]         /* Custom plugin to extend the functionality of Hvigor. */
}
