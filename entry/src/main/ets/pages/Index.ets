import { promptAction } from '@kit.ArkUI'
import { ZRouter } from 'routerapi/src/main/ets/api/Router'


@Entry
@Component
struct Index {
  aboutToAppear(): void {
    ZRouter.addGlobalInterceptor((info) => {
      console.log('GlobalInterceptor: ', JSON.stringify(info.data) , info.needLogin)
      if (info.notRegistered) {
        // 页面不存在，重定向到提示页
        ZRouter.redirect("PageNotFound")
        return
      }
      let isLogin = AppStorage.get<Boolean>("isLogin")
      if (info.needLogin && !isLogin) {
        ZRouter.redirectForResult("LoginPage", null, (data) => {
            if (data.result) {
              // 登录成功
              promptAction.showToast({ message: `登录成功` })
              return true // 返回true 则继续跳转登录前的页面
            }
            return false
          })
      }
    })

  }

  aboutToDisappear(): void {
  }


  build() {
    Navigation(ZRouter.getNavStack()){
      Column({space:12}){
        Button('toHarAMainPage').onClick((event: ClickEvent) => {
          ZRouter.push("harAMainPage")

        })

        Button('toHarBMainPage').onClick((event: ClickEvent) => {
          ZRouter.push("harBMainPage")

        })

        Button('toHspCIndex').onClick((event: ClickEvent) => {
          ZRouter.push("hspCIndex")
        })

        Button('redirectToPageNotFound').onClick((event: ClickEvent) => {
          // 页面不存在，重定向到提示页
          ZRouter.push("PageNotFound111")
        })

      }
    }
    .title('Main')
    .height('100%')
    .width('100%')
  }
}