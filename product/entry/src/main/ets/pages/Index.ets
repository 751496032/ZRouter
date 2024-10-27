import { RouterConstants } from '@hzw/common_library'
import { promptAction, router } from '@kit.ArkUI'
import { IInterceptor, ILifecycleObserver, InterceptorInfo, Lifecycle,
  LifecycleEvent,
  LifecycleRegistry, ZRouter } from 'routerapi'
import LogUtil from 'routerapi/src/main/ets/utlis/LogUtil'
import { RouterConst } from '../constants/RouterConst'
import { GlobalNavigateInterceptor, UrlInterceptor } from '../interceptors/interceptors'


@Entry
@Component
struct Index {

  @Lifecycle() lifecycle = new LifecycleRegistry()

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
    // 第一种方式设置拦截器，字面量对象的形式
    ZRouter.setInterceptor({
      priority: 100,
      process: (info: InterceptorInfo) => {
        console.log("IInterceptor process: ", 100, info.name)
        return info
      }
    } as IInterceptor)
    // 第二种方式设置拦截器，类的实例对象的形式
    ZRouter.setInterceptor(new UrlInterceptor())
    ZRouter.setGlobalInterceptor(new GlobalNavigateInterceptor())

    // 生命周期监听
    const that = this
    this.lifecycle.addObserver({
      aboutToAppear(): void {
        console.log('addObserver  aboutToAppear ' + that.lifecycle)
      },
      onPageShow(): void {
        console.log('addObserver  onPageShow')
      },

      onPageHide(): void {
        console.log('addObserver  onPageHide')
      }

    } as ILifecycleObserver)

    this.lifecycle.addListener((e) => {
      if (e == LifecycleEvent.ON_PAGE_SHOW) {
      }
    })


  }

  aboutToDisappear(): void {
  }

  // onPageShow(): void {
  //   console.log('Index  onPageShow')
  // }


  build() {
    Navigation(ZRouter.getNavStack()){
      Column({space:12}){
        Button('toHarAMainPage').onClick((event: ClickEvent) => {
          // ZRouter.push("harAMainPage")
          ZRouter.getInstance().navigation(RouterConstants.HARA_MAIN_PAGE)

        })
        Button('toHarBMainPage').onClick((event: ClickEvent) => {
          ZRouter.push(RouterConstants.HARB_MAIN_PAGE)
        })
        Button('toHspCIndex(携带参数)').onClick((event: ClickEvent) => {

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
            .navigation(RouterConstants.HSPC_INDEX_PAGE)

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
          ZRouter.getInstance().navigation(RouterConstants.URL_TEST_PAGE)
        })


        Button('退出登录').onClick((event: ClickEvent) => {
          AppStorage.set("isLogin", false)
          promptAction.showToast({ message: "已退出登录" })
          // ZRouter.getInstance().navigation(RouterConstants.ORDER_PAGE)

        })

        Button("模拟第三方Navigation使用ZRouter的API").onClick((event: ClickEvent) => {
          router.pushUrl({ url: RouterConst.INDEX2_NAME })
        }).margin({ top: 30 })


      }
    }
    .onAppear(()=>{
      let isStarted= AppStorage.get<boolean>(RouterConst.SPLASH_TAG)
      if (!isStarted) {
        ZRouter.getInstance()
          .setAnimate(false)
          .navigation(RouterConst.SPLASH_PAGE)
      }

    })
    .title('Main')
    .height('100%')
    .width('100%')
  }
}