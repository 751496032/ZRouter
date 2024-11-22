/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import { NavAnimationModifier, Route, ZRouter } from 'routerapi';

@Route({ name: RouterConstants.PAGE_DIALOG_MODE })
@Component
export struct PageDialogMode {
  modifier = new NavAnimationModifier()

  build() {
    NavDestination() {
      Column() {
        Button('自己设置的全局转场', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            ZRouter.getInstance().push(RouterConstants.PAGE_THREE)
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('PageDialogMode')
    .backgroundColor(Color.White)
    .onReady((c) => {
      ZRouter.getInstance().animateMgr().registerAnimParam(this.modifier, c)
    })
    .onDisAppear(() => {
      ZRouter.getInstance().animateMgr().unregisterAnim(this.modifier)
    })
    .attributeModifier(this.modifier)
    .mode(NavDestinationMode.DIALOG)
  }
}