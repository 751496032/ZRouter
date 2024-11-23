import { RouterConstants } from '@hzw/common_library';
import { NavAnimationModifier, Route, ZRouter } from 'routerapi';

@Route({ name: RouterConstants.HSPC_PAGE3 })
@Component
export struct Page3 {
  @State message: string = 'Hello World';
  modifier: NavAnimationModifier = new NavAnimationModifier()
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Button('pop').onClick((event: ClickEvent) => {
          ZRouter.pop()
        })
      }
    }
    .title(RouterConstants.HSPC_PAGE3)
    .onReady((context:NavDestinationContext)=>{
      // ZRouter.getInstance().registerAnimParam(this.modifier, context, {
      //   animateParam: {
      //     duration: 500,
      //     curve: Curve.Linear
      //   },
      //   startTranslateOptions: { x: '100%', y: '100%' },
      //   endTranslateOptions: { x: '0', y: '0' },
      //   startScaleOptions: {
      //     x: 0,
      //     y: 0,
      //     centerX: "50%",
      //     centerY: "50%"
      //   },
      //   endScaleOptions: {
      //     x: 1,
      //     y: 1,
      //     centerX: "50%",
      //     centerY: "50%"
      //   },
      //   startRotateOptions: {
      //     angle: 90,
      //     centerX: "50%",
      //     centerY: "50%"
      //   },
      //   endRotateOptions: {
      //     angle: 0,
      //     centerX: "50%",
      //     centerY: "50%"
      //   },
      //   startOpacity: 0.1,
      //   endOpacity: 1.0,
      // })

    })
    // .onDisAppear(() => {
    //   ZRouter.getInstance().unregisterAnim(this.modifier)
    // })
    // .attributeModifier(this.modifier)
    .width('100%')
    .height('100%')
  }
}
