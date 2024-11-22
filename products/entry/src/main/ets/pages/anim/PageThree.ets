/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc: 自己设置的全局转场
 */
import { RouterConstants } from '@hzw/common_library';
import { NavAnimationModifier, Route, ZRouter } from 'routerapi';

@Builder
export function PageThreeBuilder(name: string, param: Object) {
  PageThree()
}

@Route({ name: RouterConstants.PAGE_THREE })
@Component
export struct PageThree {
  modifier = new NavAnimationModifier()

  build() {
    NavDestination() {
      Column() {
        Button('系统默认转场', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            ZRouter.getInstance().push(RouterConstants.PAGE_FOUR)
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
    .title('自己设置的全局转场')
    .onReady((c) => {
      ZRouter.getInstance().animateMgr().registerAnimParam(this.modifier, c)
    })
    .onDisAppear(() => {
      ZRouter.getInstance().animateMgr().unregisterAnim(this.modifier)
    })
    .attributeModifier(this.modifier)
    .backgroundColor(Color.White)
  }
}