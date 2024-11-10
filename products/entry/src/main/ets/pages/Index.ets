import { RouterConstants, ToastUtils } from '@hzw/common_library'
import { promptAction, router } from '@kit.ArkUI'
import { IInterceptor, ILifecycleObserver, InterceptorInfo, Lifecycle,
  LifecycleRegistry, ZRouter } from 'routerapi'
import { RouterConst } from '../constants/RouterConst'
import { GlobalNavigateInterceptor, UrlInterceptor } from '../interceptors/interceptors'
import { AddInterceptor } from '../interceptors/AddIntercetors'


@Entry
@Component
struct Index {
  @Lifecycle
  lifecycle: LifecycleRegistry = LifecycleRegistry.create(this)

  aboutToAppear(): void {
    AddInterceptor()

    // @Entry页面生命周期监听
    const that = this
    this.lifecycle.addObserver({
      aboutToAppear(): void {
        console.log('Index  aboutToAppear ' + that.lifecycle)
      },
      onPageShow(): void {
        console.log('Index  onPageShow')
      },

      onPageHide(): void {
        console.log('Index  onPageHide')
      },
      aboutToDisappear(): void {
        console.log('Index  aboutToDisappear')
      },
    } as ILifecycleObserver)
    this.lifecycle.addListener((e)=>{

    })


  }

  build() {
    Navigation(ZRouter.getNavStack()){
      Column({space:12}){
        Button('toHarAMainPage').onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.HARA_MAIN_PAGE)

        })
        Button('toHarBMainPage').onClick((event: ClickEvent) => {
          ZRouter.push(RouterConstants.HARB_MAIN_PAGE)
        })
        Button('toHspCIndex').onClick((event: ClickEvent) => {
          let data: Record<string, string | number> = { "msg": "hello ZRouter", "num": 100 }
          ZRouter.getInstance()
            .setParam(data)
            .setPopListener((info) => {
              let msg =  `返回携带的数据：${JSON.stringify(info.data)}`
              ToastUtils.show(msg)
            })
            .navigation(RouterConstants.HSPC_INDEX_PAGE)

        })

        Button('redirectToPageNotFound').onClick((event: ClickEvent) => {
          // 页面不存在，重定向到提示页
          ZRouter.getInstance().navigation("PageNotFound111")
        })

        Button('跳转携带参数与监听pop返回所携带的参数').onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam("root data")
            .setLunchMode(LaunchMode.STANDARD) // 启动模式
            .enableCrossPageParamReturn() // 跨页面参数返回
            .setAnimate(true)
            .setPopListener((r) => {
                ToastUtils.show(`pop result: ${r.data}  from: ${r.from}`)
            })
            .navigation(RouterConstants.HARA_PAGE3)
        })


        Button("自定义URL跳转").onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.CUSTOM_URL_PAGE)
        })

        Button("服务路由-实现模块通信").onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.SERVICE_CASE_VIEW)
        })

        Button("生命周期函数管理").onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.LIFECYCLE_CASE_VIEW)
        })


        Button('退出登录').onClick((event: ClickEvent) => {
          AppStorage.set<boolean>("isLogin", false)
          promptAction.showToast({ message: "已退出登录" })
        })

        Button("模拟第三方Navigation实例使用ZRouter库的Api").onClick((event: ClickEvent) => {
          router.pushUrl({ url: RouterConst.NAV_PAGE })
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