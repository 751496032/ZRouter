import { promptAction } from '@kit.ArkUI'
import { PopResult, ZRouter } from 'routerapi'
import LogUtil from 'routerapi/src/main/ets/utlis/LogUtil'


@Entry
@Component
struct Index {
  aboutToAppear(): void {
    ZRouter.addGlobalInterceptor((info) => {
      LogUtil.log('GlobalInterceptor: ', JSON.stringify(info.metadata) , info.isNeedLogin)
      if (info.notRegistered) {
        // 页面不存在，重定向到提示页 PageNotFound
        ZRouter.redirect("PageNotFound2")
        return
      }
      let isLogin = AppStorage.get<boolean>("isLogin")
      if (info.isNeedLogin && !isLogin) {
        let param = ZRouter.getParamByName(info.metadata?.name ?? "")
        ZRouter.redirectForResult2<boolean>("LoginPage", param, (data) => {
            if (data.data) {
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
    Navigation(ZRouter.getNavStack((from: NavDestinationContext | NavBar, to: NavDestinationContext | NavBar, operation: NavigationOperation, isAnimated: boolean)=> {
      if (to === 'navBar') {
        LogUtil.log('willShow: 即将显示首页', to)
      } else if (to.pathInfo !== undefined) {
        LogUtil.log('willShow:', to.pathInfo.name)
      } else {
        LogUtil.log('willShow: 重定向到不存在的页面', to)
      }
    })){
      Column({space:12}){
        Button('toHarAMainPage').onClick((event: ClickEvent) => {
          ZRouter.push("harAMainPage")

        })

        Button('toHarBMainPage').onClick((event: ClickEvent) => {
          ZRouter.push("harBMainPage")

        })

        Button('toHspCIndex(携带参数)').onClick((event: ClickEvent) => {
          // let data = 'hello ZRouter'
          // let data = 100
          // let data : List<string> = new List<string>()
          // data.add('hello ZRouter')
          // data.add('100')
          let data: Record<string, string | number> = { "msg": "hello ZRouter", "num": 100 }
          ZRouter.pushForResult("hspCIndex", data, (info) => {
            console.log('hspCIndex 返回携带的数据：', info.result)
            promptAction.showDialog({message: `返回携带的数据：${JSON.stringify(info.result)}`})
          })
        })

        Button('redirectToPageNotFound').onClick((event: ClickEvent) => {
          // 页面不存在，重定向到提示页
          ZRouter.push("PageNotFound111")
        })

        Button('监听pop携带的参数').onClick((event: ClickEvent) => {
          // ZRouter.push("harAPage3")
          ZRouter.pushNavForResult<string>("harAPage3", "root data", (r: PopResult<string>) => {
            LogUtil.log("index result: ", r.data ," from: ", r.from);
          })
        })


        Button('退出登录').onClick((event: ClickEvent) => {
          AppStorage.set("isLogin", false)

        })

      }
    }
    .title('Main')
    .height('100%')
    .width('100%')
  }
}