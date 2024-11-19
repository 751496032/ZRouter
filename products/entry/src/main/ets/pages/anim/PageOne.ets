/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { NavAnimationModifier, Route, ZRouter } from 'routerapi';
import { AnimConst } from './AnimConst';

@Builder
export function PageOneBuilder(name: string, param: Object) {
  PageOne()
}

@Route({ name: "PageOne" })
@Component
export struct PageOne {
  modifier: NavAnimationModifier = new NavAnimationModifier()
  rectWidth: number = 0;
  interactive: boolean = false;

  build() {
    NavDestination() {
      Column() {
        Button('空白页', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            ZRouter.getInstance().push('PageThree')
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
      switch (ZRouter.getParam()) {
        case AnimConst.TRANSLATE:
          // 平移
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
              startTranslateOptions: { x: '100%', y: '100%' },
              endTranslateOptions: { x: '0', y: '0' },
            })
            .setPopExitAnimate({
              startTranslateOptions: { x: '0', y: '0' },
              endTranslateOptions: { x: '0', y: '100%' },
            })
          break
        case AnimConst.SCALE:
          // 缩放
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
              startScaleOptions: {
                x: 0,
                y: 0,
                centerX: '50%',
                centerY: '50%',
              },
              endScaleOptions: {
                x: 1,
                y: 1,
                centerX: '50%',
                centerY: '50%',
              },
            })
            .setPopExitAnimate({
              startScaleOptions: {
                x: 1,
                y: 1,
                centerX: '0',
                centerY: '0',
              },
              endScaleOptions: {
                x: 0,
                y: 0,
                centerX: '0',
                centerY: '0',
              },
            })
          break
        case AnimConst.OPACITY:
          // 渐变
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
              startOpacity: 0,
              endOpacity: 1,
            })
            .setPopExitAnimate({
              startOpacity: 1,
              endOpacity: 0,
            })
          break
        case AnimConst.ROTATE:
          // 旋转
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
              startRotateOptions: {
                angle: 90,
                centerX: '100%',
                centerY: '100%',
              },
              endRotateOptions: {
                angle: 0,
                centerX: '100%',
                centerY: '100%',
              }
            })
            .setPopExitAnimate({
              startRotateOptions: {
                angle: 0,
                centerX: '50%',
                centerY: '50%',
              },
              endRotateOptions: {
                angle: 360,
                centerX: '50%',
                centerY: '50%',
              },
            })
          break
        default:
        // 组合
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
              startTranslateOptions: { x: '100%', y: '100%' },
              endTranslateOptions: { x: '0', y: '0' },
              startScaleOptions: {
                x: 0,
                y: 0,
                centerX: '50%',
                centerY: '50%',
              },
              endScaleOptions: {
                x: 1,
                y: 1,
                centerX: '50%',
                centerY: '50%',
              },
              startOpacity: 0,
              endOpacity: 1,
              startRotateOptions: {
                angle: 90,
                centerX: '50%',
                centerY: '50%',
              },
              endRotateOptions: {
                angle: 0,
                centerX: '50%',
                centerY: '50%',
              }
            })
            .setPopExitAnimate({
              startScaleOptions: {
                x: 1,
                y: 1,
                centerX: '50%',
                centerY: '50%',
              },
              endScaleOptions: {
                x: 0,
                y: 0,
                centerX: '0',
                centerY: '0',
              },
              startOpacity: 1,
              endOpacity: 0,
              startRotateOptions: {
                angle: 0,
                centerX: '100%',
                centerY: '100%',
              },
              endRotateOptions: {
                angle: 360,
                centerX: '50%',
                centerY: '50%',
              },
            })
      }
    })
    .onDisAppear(() => {
      ZRouter.getInstance().unregisterAnim(this.modifier)
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