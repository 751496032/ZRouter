/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { NavAnimationModifier, Route, ZRouter } from 'routerapi';

@Builder
export function PageThreeBuilder(name: string, param: Object) {
  PageThree()
}

@Route({ name: "PageThree" })
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
            ZRouter.getInstance().push('PageFour')
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('自己设置的全局转场')
    .onReady((c) => {
      ZRouter.getInstance().registerAnimParam(this.modifier, c)
    })
    .onDisAppear(() => {
      ZRouter.getInstance().unregisterAnim(this.modifier)
    })
    .attributeModifier(this.modifier)
    .backgroundColor(Color.White)
  }
}