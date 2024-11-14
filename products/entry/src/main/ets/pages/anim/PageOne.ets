/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { NavAnimationXOptions, Route, ZRouter } from 'routerapi';
import { NavAnimationMgr } from 'routerapi/src/main/ets/animation/NavAnimationMgr';
import { NavDestinationModifier } from '@kit.ArkUI';

@Builder
export function PageOneBuilder(name: string, param: Object) {
  PageOne()
}

@Route({ name: "PageOne" })
@Component
export struct PageOne {
  @State modifier: NavDestinationModifier = new NavDestinationModifier()
  rectWidth: number = 0;
  interactive: boolean = false;

  build() {
    NavDestination() {
      Column() {
        Button(`setInteractive`)
          .onClick(() => {
            NavAnimationMgr.getInstance().interactive = !NavAnimationMgr.getInstance().interactive;
            this.interactive = NavAnimationMgr.getInstance().interactive;
          })

        Button('PageTwo', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            ZRouter.getInstance().push('PageTwo')
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('pageOne')
    .onReady((context: NavDestinationContext) => {
      ZRouter.getInstance().registerAnim(this, context, new NavAnimationXOptions((m) => this.modifier = m))
    })
    .onDisAppear(() => {
      ZRouter.getInstance().unregisterAnim(this)
    })
    .attributeModifier(this.modifier)
    .backgroundColor('#F1F3F5')

    // .gesture(PanGesture()
    //   .onActionStart((event: GestureEvent) => {
    //     this.rectWidth = event.target.area.width as number;
    //     if (event.offsetX < 0) {
    //       this.pageInfos.pushPath({ name: 'pageTwo', param: NavAnimationBuilder.getInstance().getAnimationId() });
    //     } else {
    //       this.pageInfos.pop();
    //     }
    //   })
    //   .onActionUpdate((event: GestureEvent) => {
    //     let rate = event.fingerList[0].localX / this.rectWidth;
    //     NavAnimationBuilder.getInstance().updateProgress(rate);
    //   })
    //   .onActionEnd((event: GestureEvent) => {
    //     let rate: number = event.fingerList[0].localX / this.rectWidth;
    //     NavAnimationBuilder.getInstance().finishInteractiveAnimation(rate);
    //   }))
  }
}