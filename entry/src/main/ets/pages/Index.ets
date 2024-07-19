import { promptAction } from '@kit.ArkUI'
import { ZRouter } from 'routerapi/src/main/ets/api/Router'


@Entry
@Component
struct Index {
  aboutToAppear(): void {
    ZRouter.addGlobalInterceptor((info) => {
      console.log('GlobalInterceptor: ', JSON.stringify(info.data) , info.needLogin)
      let isLogin = AppStorage.get<Boolean>("isLogin")
      if (info.needLogin && !isLogin) {
        ZRouter.pushForResult("LoginPage", null, (data) => {
            if (data.result) {
              // 登录成功
              promptAction.showToast({ message: '登录成功' })
            }
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

      }
    }
    .title('Main')
    .height('100%')
    .width('100%')
  }
}