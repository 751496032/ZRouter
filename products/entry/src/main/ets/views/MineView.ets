/**
 * @author: HZWei
 * @date: 2025/5/24
 * @desc:
 */
import { promptAction } from '@kit.ArkUI'
import { GlobalNavInterceptorMgr } from '../interceptors/interceptors'

@ComponentV2
export struct MineView {
  @Param onLogout: () => void = () => {

  }
  build() {
    Column({ space: 10 }) {
      Button('退出登录').onClick((event: ClickEvent) => {
        AppStorage.set<boolean>("isLogin", false)
        GlobalNavInterceptorMgr.count = 0
        promptAction.showToast({ message: "已退出登录" })
        this.onLogout?.()
      })
    }
  }
}