
import { OpacityAnimateOptions, Route, ScaleAnimateOptions, ZRouter } from 'routerapi';
import { RouterConst } from '../constants/RouterConst';
/**
 * @author: HZWei
 * @date: 2024/10/12
 * @desc:
 */
@Route({ name: RouterConst.SPLASH_PAGE })
@Component
export struct SplashPage {
  @State countdown: number = 3000

  build() {
    NavDestination() {
      Column() {
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
          ZRouter.getInstance().pop(true)
        }
      }, 1000)
    })
    .onDisAppear(()=>{
      ZRouter.animateMgr().unregisterAnim(this)
      AppStorage.setOrCreate(RouterConst.SPLASH_TAG,true)
    })
  }
}