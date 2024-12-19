import { RouterConstants, ToastUtils } from '@hzw/common_library'
import { promptAction, router } from '@kit.ArkUI'
import { ILifecycleObserver, Lifecycle, LifecycleRegistry,
  OpacityAnimateOptions,
  RotateAnimateOptions,
  ScaleAnimateOptions,
  TranslateAnimationOptions, ZRouter } from 'routerapi'
import { RouterConst } from '../constants/RouterConst'
import { AddInterceptor } from '../interceptors/AddIntercetors'
import { common, Want } from '@kit.AbilityKit'
import { BusinessError } from '@kit.BasicServicesKit'

@Entry
@Component
struct Index {
  @Lifecycle
  lifecycle: LifecycleRegistry = LifecycleRegistry.create(this)
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {

    ZRouter.setModuleLoadedListener(() => {
      // 模块加载完成
      console.log("Index 模块加载完成")
    })

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
    this.lifecycle.addListener((e) => {

    })

  }

  build() {
    Navigation(ZRouter.getNavStack()) {
      Scroll(){
        Column({ space: 12 }) {
          Button('har-跳转到HarA模块').onClick((event: ClickEvent) => {
            ZRouter.getInstance().navigation(RouterConstants.HARA_MAIN_PAGE)

          })
          Button('har-跳转到HarB模块').onClick((event: ClickEvent) => {
            ZRouter.push(RouterConstants.HARB_MAIN_PAGE)
          })
          Button('hsp-跳转到Hsp模块').onClick((event: ClickEvent) => {
            let data: Record<string, string | number> = { "msg": "hello ZRouter", "num": 100 }
            ZRouter.getInstance()
              .setParam(data)
              .setPopListener((info) => {
                let msg = `返回携带的数据：${JSON.stringify(info.data)}`
                ToastUtils.show(msg)
              })
              .navigation(RouterConstants.HSPC_INDEX_PAGE)
          })

          Button("hap-跳转到Hap模块").onClick((event: ClickEvent) => {
            let want: Want = {
              deviceId: '', // deviceId为空表示本设备
              bundleName: 'com.harmony.router',
              abilityName: 'HapAAbility',
              moduleName: 'hapA', // moduleName非必选
              parameters: {
                // 自定义信息
                route: RouterConstants.ORDER_PAGE
              }
            };
            this.context.startAbility(want).then(() => {
              console.info("startAbility", '已启动Ability');
            }).catch((err: BusinessError) => {
              // https://developer.huawei.com/consumer/cn/doc/harmonyos-faqs-V5/faqs-ability-7-V5
              console.error("startAbility", `启动Ability失败. Code: ${err.code}, message: ${err.message}`);
            })
          })


          Button('404页面').onClick((event: ClickEvent) => {
            // 页面不存在，重定向到提示页
            ZRouter.getInstance().navigation("PageNotFound111")
          })

          Button('跳转携带参数与监听pop返回所携带的参数').onClick((event: ClickEvent) => {
            ZRouter.getInstance()
              .setParam("root data")
              .setLunchMode(LaunchMode.STANDARD)// 启动模式
              .enableCrossPageParamReturn()// 跨页面参数返回
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

          Button("转场动画").onClick((event: ClickEvent) => {
            ZRouter.getInstance().navigation(RouterConstants.ANIM_DEMO)
          })

          Button("NavDestination页面模板化").onClick((event: ClickEvent) => {
            ZRouter.getInstance().navigation(RouterConstants.CUSTOM_COMPONENT_CHILD_VIEW)
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
    }
    .onAppear(() => {
      let isStarted = AppStorage.get<boolean>(RouterConst.SPLASH_TAG)
      if (!isStarted) {
        ZRouter.getInstance()
          .setAnimate(false)
          .navigation(RouterConst.SPLASH_PAGE)
      }
    })
    .title('Main')
    .height('100%')
    .width('100%')
    .customNavContentTransition(ZRouter.animateMgr()
      // 创建默认动画管理器
      .defaultAnimateBuilder()
      // 设置进场动画参数
      .setEnterAnimate({ duration: 500 })
        // 设置退场动画参数
      .setExitAnimate({ duration: 700 })
      // 平移
      .addAnimateOptions(new TranslateAnimationOptions({ x:'50%',y:'50%'}))
      // 渐变
      .addAnimateOptions(new OpacityAnimateOptions(0.01))
      // 缩放
      .addAnimateOptions(new ScaleAnimateOptions({ x:0, y: 0 }))
      // 旋转
      .addAnimateOptions(new RotateAnimateOptions({ angle: 90 }))
      // 自定义转场动画回调
      .getAnimCustomNavContentTransition())
  }
}