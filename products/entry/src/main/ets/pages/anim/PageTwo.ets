/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { NavAnimationYOptions, Route, ZRouter } from 'routerapi';
import { NavDestinationModifier } from '@kit.ArkUI';

@Builder
export function PageTwoBuilder(name: string, param: Object) {
  PageTwo()
}

@Route({ name: "PageTwo" })
@Component
export struct PageTwo {
  @State modifier: NavDestinationModifier = new NavDestinationModifier()

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
      ZRouter.getInstance().registerAnim(this, context, new NavAnimationYOptions((m) => this.modifier = m))
    })
    .onDisAppear(() => {
      ZRouter.getInstance().unregisterAnim(this)
    })
    .attributeModifier(this.modifier)
    .backgroundColor(Color.Yellow)
  }
}