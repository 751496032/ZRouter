
import {
  ILifecycleObserver,
  Lifecycle,
  LifecycleRegistry,
  OpacityAnimateOptions,
  RotateAnimateOptions,
  ScaleAnimateOptions,
  TranslateAnimationOptions,
  ZRouter
} from 'routerapi'
import { RouterConst } from '../constants/RouterConst'
import { AddInterceptor } from '../interceptors/AddIntercetors'
import { MainView } from './MainView'
import onBackPress from './onBackPress'

@Entry
@Component
struct Index {
  @Lifecycle
  lifecycle: LifecycleRegistry = LifecycleRegistry.create(this)
  @State isShowMainView: boolean = false

  aboutToAppear(): void {
    AddInterceptor()
    ZRouter.setModuleLoadedListener(() => {
      // 模块加载完成
      console.log("Index 模块加载完成")
    })

    // @Entry页面生命周期监听 onPageShow onPageHide
    // 如果在Navigation根视图中设置生命周期监听，建议将inRootView设置为true
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
      onWillShow(){
        console.log('Index  onWillShow')
      }
    } as ILifecycleObserver, true)
    // this.lifecycle.addListener((e) => {
    //
    // }, true)

  }

  onBackPress(): boolean | void {
    console.log('Index  onBackPress')
    return onBackPress()
  }

  build() {
    Navigation(ZRouter.getNavStack()) {
      if (this.isShowMainView){
        MainView()
      }
    }
    .onAppear(() => {
      let isStarted = AppStorage.get<boolean>(RouterConst.SPLASH_TAG)
      if (!isStarted) {
        ZRouter.getInstance()
          .setAnimate(false)
          .setPopListener((r)=>{
           console.log('Index  setPopListener',r)
           this.isShowMainView = true
          })
          .navigation(RouterConst.SPLASH_PAGE)
      }
    })
    .title('Main')
    .height('100%')
    .width('100%')
    .customNavContentTransition(ZRouter.animateMgr()// 创建默认动画管理器
      .defaultAnimateBuilder()// 设置进场动画参数
      .setEnterAnimate({ duration: 500 })// 设置退场动画参数
      .setExitAnimate({ duration: 700 })// 平移
      .addAnimateOptions(new TranslateAnimationOptions({ x: '50%', y: '50%' }))// 渐变
      .addAnimateOptions(new OpacityAnimateOptions(0.01))// 缩放
      .addAnimateOptions(new ScaleAnimateOptions({ x: 0, y: 0 }))// 旋转
      .addAnimateOptions(new RotateAnimateOptions({ angle: 90 }))// 自定义转场动画回调
      .getAnimCustomNavContentTransition())
  }
}