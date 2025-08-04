import { PreferencesUtil, RouterConstants } from '@hzw/common_library';
import { OpacityAnimateOptions, Route, ScaleAnimateOptions, ZRouter } from 'routerapi';
import { RouterConst } from '../constants/RouterConst';
/**
 * @author: HZWei
 * @date: 2024/10/12
 * @desc: 如果@Route不设置任何属性，则默认使用类名作为路由名称
 */
@Route({
  param: {
    "ids": {
      default: -1
    }
  }
})
@Component
export struct SplashPage {
  @State ids: number = -1
  @State countdown: number = 3000

  build() {
    NavDestination() {
      Column() {
        Text("测试id参数=" + this.ids)
        Text('欢迎使用ZRouter')
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)
          .padding(30)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Center)

        Text(this.countdown / 1000 + "")
          .fontColor(Color.Red)
          .textAlign(TextAlign.Center)
          .padding(30)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .alignSelf(ItemAlign.Center)

      }.width('100%')
      .height('100%')
    }.width('100%')
    .height('100%')
    .hideTitleBar(true)
    .onReady((context=>{
      ZRouter
        .animateMgr()
        .registerAnimParam(this, context)
        .addAnimateOptions(new ScaleAnimateOptions({ x: 0, y: 0 }))
        .addAnimateOptions(new OpacityAnimateOptions(0.5))
    }))
    .attributeModifier(ZRouter.animateMgr().modifier(this))
    .onAppear(() => {
      setInterval(() => {
        this.countdown -= 1000
        if (this.countdown === 0) {
          const hideNavbar = PreferencesUtil.get<boolean>("hideNavbar") ?? false
          if (hideNavbar) {
            ZRouter.getInstance().replaceWithDefaultAnim(RouterConstants.MAIN_PAGE)
          } else {
            ZRouter.getInstance().popWithResult(true)
          }

        }
      }, 1000)
    })
    .onDisAppear(()=>{
      ZRouter.animateMgr().unregisterAnim(this)
      AppStorage.setOrCreate(RouterConst.SPLASH_TAG,true)
    })
    .onBackPressed(() => true)
  }
}