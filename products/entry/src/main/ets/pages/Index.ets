import { RouterConstants } from '@hzw/common_library'
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
import { GlobalNavInterceptorMgr } from '../interceptors/interceptors'
import { AnimView } from '../views/AnimView'
import { BottomNavigationBar } from '../views/BottomNavigationBar'
import { MainView } from '../views/MainView'
import { MineView } from '../views/MineView'
import onBackPress from './onBackPress'

@Entry
@Component
struct Index {
  // 生命周期管理 如果使用模板化能力，LifecycleRegistry则不需要创建，ZRouter会自动创建接管NavDestiantion的生命周期
  @Lifecycle
  lifecycle: LifecycleRegistry = LifecycleRegistry.create(this)
  @State isShowContent: boolean = false

  aboutToAppear(): void {
    // 添加拦截器
    AddInterceptor()
    // 监听模块是否加载完成 服务路由
    ZRouter.setModuleLoadedListener(() => {
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
      onWillShow() {
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
    // 初始化Navigation路由栈 ，必选
    Navigation(ZRouter.getNavStack()) {
      if (this.isShowContent) {
        MainContentView()
      }
    }
    .onAppear(() => {
      let isStarted = AppStorage.get<boolean>(RouterConst.SPLASH_TAG)
      if (!isStarted) {
        ZRouter.getInstance()
          .setParam(Object({ids: 1}))
          .setAnimate(false)
          .setPopListener((r) => {
            console.log('Index  setPopListener', r)
            this.isShowContent = true
          })
          .navigation(RouterConst.SPLASH_PAGE)
      }
    })
    .hideTitleBar(true)
    .title('Main')
    .height('100%')
    .width('100%')
    // 可选
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


@ComponentV2
struct MainContentView {
  @Local currentIndex: number = 0;
  previousIndex: number = -1;

  aboutToAppear(): void {
    GlobalNavInterceptorMgr.onRootShow = () => {
      if (this.isLogin && this.previousIndex > 0) {
        this.currentIndex = this.previousIndex
      }
      if (this.previousIndex > 0) {
        this.previousIndex = -1
      }
    }
  }

  build() {
    Column() {
      Tabs({ index: this.currentIndex }) {
        TabContent() {
          MainView()
        }

        TabContent() {
          AnimView()
        }

        TabContent() {
          MineView({onLogout: () => {
            this.currentIndex = 0
          }})
        }
      }
      .barMode(BarMode.Fixed)
      .scrollable(false)
      .layoutWeight(1)
      .barHeight(0)

      BottomNavigationBar({
        currentIndex: this.currentIndex!!,
        onItemClick: (index) => {
          if (index === 2) {
            if (!this.isLogin) {
              this.previousIndex = index
              ZRouter.getInstance().navigation(RouterConstants.LOGIN_PAGE)
              return true
            }
          }
          return false
        }

      })
    }.width('100%')
    .height('100%')
  }

  private get isLogin() {
    return AppStorage.get<boolean>('isLogin')
  }
}

