/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { NavAnimationModifier, Route, ZRouter } from 'routerapi';

@Builder
export function PageTwoBuilder(name: string, param: Object) {
  PageTwo()
}

@Route({ name: "PageTwo" })
@Component
export struct PageTwo {
  modifier: NavAnimationModifier = new NavAnimationModifier()

  build() {
    NavDestination() {
      Column() {
        Button('PageOne', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            //将name指定的NavDestination页面信息入栈，传递的数据为param
            ZRouter.getInstance().push('PageOne')
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('pageTwo')
    // .gesture(PanGesture()
    //   .onActionStart((event: GestureEvent) => {
    //     this.rectWidth = event.target.area.width as number;
    //     if (event.offsetX < 0) {
    //       this.pageInfos.pushPath({ name: 'PageOne', param: CustomTransition.getInstance().getAnimationId() });
    //     } else {
    //       this.pageInfos.pop();
    //     }
    //   })
    //   .onActionUpdate((event: GestureEvent) => {
    //     let rate = event.fingerList[0].localX / this.rectWidth;
    //     CustomTransition.getInstance().updateProgress(rate);
    //   })
    //   .onActionEnd((event: GestureEvent) => {
    //     let rate = event.fingerList[0].localX / this.rectWidth;
    //     CustomTransition.getInstance().finishInteractiveAnimation(rate);
    //   }))
    // .onAppear(() => {
    //   this.registerCallback();
    // })
    .onReady((context: NavDestinationContext) => {
      ZRouter.getInstance()
        .buildAnimParam(this.modifier, context)
        .setAnimateParam({
          duration: 1000,
          curve: Curve.EaseIn
        })
        .translateStart({ x: '100%', y: '0' })
        .translateEnd({ x: '0', y: '0' })
        .scaleStart({
          x: 0,
          y: 0,
          centerX: "50%",
          centerY: "50%"
        })
        .scaleEnd({
          x: 1,
          y: 1,
          centerX: "50%",
          centerY: "50%"
        })
        .rotateStart({
          angle: 90,
          centerX: "50%",
          centerY: "50%"
        })
        .rotateEnd({
          angle: 0,
          centerX: "50%",
          centerY: "50%"
        })
        .opacityStart(0.1)
        .opacityEnd(1.0)
        .build()
    })
    .onDisAppear(() => {
      ZRouter.getInstance().unregisterAnim(this.modifier)
    })
    .attributeModifier(this.modifier)
    .backgroundColor(Color.Yellow)
  }
}