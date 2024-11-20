/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { NavAnimationModifier, Route, ZRouter } from 'routerapi';

@Builder
export function PageTwoBuilder(name: string, param: Object) {
  PageThree()
}

@Route({ name: "PageThree" })
@Component
export struct PageThree {
  modifier: NavAnimationModifier = new NavAnimationModifier()

  build() {
    NavDestination() {
      Column() {
        Text("空白页")
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('PageThree')
    .onReady((ctx) => {
      ZRouter.getInstance().registerAnimParam(this.modifier, ctx)
        .setPushEnterAnimate({
          animateParam: {
            duration: 1000,
          },
          startCallback: (m) => m.attribute?.translate({ x: '100%' }),
          endCallback: (m) => m.attribute?.translate({ x: '0' }),
        })
        .setPopExitAnimate({
          animateParam: {
            duration: 1000,
          },
          startCallback: (m) => m.attribute?.translate({ x: '0' }),
          endCallback: (m) => m.attribute?.translate({ x: '100%' }),
        })
    })
    .onDisAppear(() => {
      ZRouter.getInstance().unregisterAnim(this.modifier)
    })
    .attributeModifier(this.modifier)
    .backgroundColor(Color.White)
  }
}