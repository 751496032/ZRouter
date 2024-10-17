import { hapTasks } from '@ohos/hvigor-ohos-plugin';
import { routerRegisterPlugin, PluginConfig } from 'router-register-plugin'
const config: PluginConfig = {
    scanDirs: ['src/main/ets/pages', 'src/main/ets/views'], // 扫描的目录，如果不设置，默认是扫描src/main/ets目录
    logEnabled: true, // 查看日志
    viewNodeInfo: false, // 查看节点信息
    isAutoDeleteHistoryFiles: true // 删除历史无用文件

}
export default {
    system: hapTasks,  /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins:[routerRegisterPlugin(config)]         /* Custom plugin to extend the functionality of Hvigor. */
}
