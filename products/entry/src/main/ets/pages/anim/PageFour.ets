/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc: 系统默认转场
 */
import { RouterConstants } from '@hzw/common_library';
import { NavAnimationModifier, Route, ZRouter } from 'routerapi';

@Builder
export function PageFourBuilder(name: string, param: Object) {
  PageFour()
}

@Route({ name: RouterConstants.PAGE_FOUR })
@Component
export struct PageFour {
  modifier: NavAnimationModifier = new NavAnimationModifier()

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
        Button('返回动画 demo 首页', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            ZRouter.getInstance().popToName(RouterConstants.ANIM_DEMO)
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('系统默认转场')
    .backgroundColor(Color.White)
  }
}