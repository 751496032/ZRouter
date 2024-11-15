/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { Route, ZRouter } from 'routerapi';
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
        // Button(`setInteractive`)
        //   .onClick(() => {
        //     NavAnimationMgr.getInstance().interactive = !NavAnimationMgr.getInstance().interactive;
        //     this.interactive = NavAnimationMgr.getInstance().interactive;
        //   })

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
      ZRouter.getInstance().registerAnimParam(this, context, {
        // 通过更新modifier来更新动画，必传
        update: (m) => this.modifier = m,
        animateParam: {
          duration: 500,
          curve: Curve.Linear
        },
        startTranslateOptions: { x: '100%', y: '100%' },
        endTranslateOptions: { x: '0', y: '0' },
        startScaleOptions: {
          x: 0,
          y: 0,
          centerX: "50%",
          centerY: "50%"
        },
        endScaleOptions: {
          x: 1,
          y: 1,
          centerX: "50%",
          centerY: "50%"
        },
        startRotateOptions: {
          angle: 90,
          centerX: "50%",
          centerY: "50%"
        },
        endRotateOptions: {
          angle: 0,
          centerX: "50%",
          centerY: "50%"
        },
        startOpacity: 0.1,
        endOpacity: 1.0,
      })
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