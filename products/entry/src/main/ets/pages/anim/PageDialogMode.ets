/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import { Route, TranslateAnimationOptions, ZRouter } from 'routerapi';

@Route({ name: RouterConstants.PAGE_DIALOG_MODE })
@Component
export struct PageDialogMode {

  aboutToAppear(): void {

  }
  build() {
    NavDestination() {
      Column(){
        Divider()
          .layoutWeight(1)
        Column() {
          Button('自己设置的全局转场', { stateEffect: true, type: ButtonType.Capsule })
            .width('80%')
            .height(40)
            .margin(20)
            .onClick(() => {
              ZRouter.getInstance().push(RouterConstants.PAGE_THREE)
            })
        }
        .backgroundColor(Color.White)
        .size({ width: '100%', height: '60%' })
      }
    }
    .title('PageDialogMode')
    .onReady((c) => {
      ZRouter.animateMgr()
        .registerAnimParam(this, c)
        .setEnterAnimate({ duration: 300 })
        .setExitAnimate({ duration: 300 })
        .addAnimateOptions(new TranslateAnimationOptions({ y: '100%' }))


    })
    .onDisAppear(() => {
      ZRouter.animateMgr().unregisterAnim(this)
    })
    .attributeModifier(ZRouter.animateMgr().modifier(this))
    .mode(NavDestinationMode.DIALOG)
    .expandSafeArea([SafeAreaType.KEYBOARD])
    .hideTitleBar(true)
    .backgroundColor("#60000000")

  }
}