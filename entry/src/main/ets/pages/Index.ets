import { promptAction } from '@kit.ArkUI'
import {  ZRouter } from 'routerapi'
import LogUtil from 'routerapi/src/main/ets/utlis/LogUtil'
import { GlobalNavigateInterceptor } from '../interceptors/interceptors'


@Entry
@Component
struct Index {
  aboutToAppear(): void {
    // ZRouter.addGlobalInterceptor((info) => {
    //   // LogUtil.log('GlobalInterceptor: ', JSON.stringify(info.metadata) , info.isNeedLogin)
    //   if (info.notRegistered) {
    //     // 页面不存在，重定向到提示页 PageNotFound
    //     ZRouter.redirect("PageNotFound2")
    //     return
    //   }
    //   let isLogin = AppStorage.get<boolean>("isLogin")
    //   if (info.isNeedLogin && !isLogin) {
    //     let param = ZRouter.getParamByName(info.metadata?.name ?? "")
    //     ZRouter.redirectForResult2<boolean>("LoginPage", param, (data) => {
    //         if (data.data) {
    //           // 登录成功
    //           promptAction.showToast({ message: `登录成功` })
    //           return true // 返回true 则继续跳转登录前的页面
    //         }
    //         return false
    //       })
    //   }
    // })

    ZRouter.setGlobalInterceptor(new GlobalNavigateInterceptor())

  }

  aboutToDisappear(): void {
  }


  build() {
    Navigation(ZRouter.getNavStack()){
      Column({space:12}){
        Button('toHarAMainPage').onClick((event: ClickEvent) => {
          // ZRouter.push("harAMainPage")
          ZRouter.getInstance().navigation("harAMainPage")

        })

        Button('toHarBMainPage').onClick((event: ClickEvent) => {
          // ZRouter.push("harBMainPage")
          ZRouter.getInstance().navigation("harBMainPage")

        })

        Button('toHspCIndex(携带参数)').onClick((event: ClickEvent) => {
          // let data = 'hello ZRouter'
          // let data = 100
          // let data : List<string> = new List<string>()
          // data.add('hello ZRouter')
          // data.add('100')
          let data: Record<string, string | number> = { "msg": "hello ZRouter", "num": 100 }
          // ZRouter.pushForResult("hspCIndex", data, (info) => {
          //   console.log('hspCIndex 返回携带的数据：', info.result)
          //   promptAction.showDialog({message: `返回携带的数据：${JSON.stringify(info.result)}`})
          // })

          ZRouter.getInstance()
            .setParam(data)
            .setPopListener((info) => {
              console.log('hspCIndex 返回携带的数据：', info.data)
              promptAction.showDialog({ message: `返回携带的数据：${JSON.stringify(info.data)}` })
            })
            .navigation("hspCIndex")

        })

        Button('redirectToPageNotFound').onClick((event: ClickEvent) => {
          // 页面不存在，重定向到提示页
          // ZRouter.push("PageNotFound111")
          ZRouter.getInstance().navigation("PageNotFound111")
        })

        Button('监听pop携带的参数').onClick((event: ClickEvent) => {
          // ZRouter.push("harAPage3")
          // ZRouter.pushNavForResult<string>("harAPage3", "root data", (r: PopResult<string>) => {
          //   LogUtil.log("index result: ", r.data ," from: ", r.from);
          // })

          ZRouter.getInstance()
            .setParam("root data")
            .setLunchMode(LaunchMode.STANDARD) // 启动模式
            .enableCrossPageParamReturn() // 跨页面参数返回
            .setAnimate(false)
            .setPopListener((r) => {
                LogUtil.log("index result: ", r.data ," from: ", r.from);
            })
            .navigation("harAPage3")
        })


        Button("自定义URL跳转").onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation("URLPage")
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