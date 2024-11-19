/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { NavAnimationModifier, NavAnimSingleParamBuilder, Route, ZRouter } from 'routerapi';
import { AnimConst } from './AnimConst';

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
      Column({ space: 15 }) {
        Text('进入新页面时，该页面退场动画 \n 新页面退出时，该页面的进场动画')
        Button("平移").onClick((event: ClickEvent) => {
          this.setAnim(AnimConst.TRANSLATE)
          ZRouter.getInstance()
            .navigation("PageThree")
        })
        Button("缩放").onClick((event: ClickEvent) => {
          this.setAnim(AnimConst.SCALE)
          ZRouter.getInstance()
            .navigation("PageThree")
        })
        Button("渐变").onClick((event: ClickEvent) => {
          this.setAnim(AnimConst.OPACITY)
          ZRouter.getInstance()
            .navigation("PageThree")
        })
        Button("旋转").onClick((event: ClickEvent) => {
          this.setAnim(AnimConst.ROTATE)
          ZRouter.getInstance()
            .navigation("PageThree")
        })
        Button("组合").onClick((event: ClickEvent) => {
          this.setAnim("")
          ZRouter.getInstance()
            .navigation("PageThree")
        })
        Button('PageTwo进场/退场动画+PageOne进场/退场动画', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.setAnim("")
            //将name指定的NavDestination页面信息入栈，传递的数据为param
            ZRouter.getInstance().navigation('PageOne')
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('pageTwo')
    .onReady((context: NavDestinationContext) => {
      ZRouter.getInstance().registerAnimParam(this.modifier, context)
    })
    .onDisAppear(() => {
      ZRouter.getInstance().unregisterAnim(this.modifier)
    })
    .attributeModifier(this.modifier)
    .backgroundColor(Color.Yellow)
  }

  private setAnim(type: string) {
    switch (type) {
      case AnimConst.TRANSLATE:
        // 平移
        ZRouter.getInstance()
          .getAnimParamBuilder(this.modifier)
        ?.setPopEnterAnimate({
          startTranslateOptions: { x: '100%', y: '100%' },
          endTranslateOptions: { x: '0', y: '0' },
        })
          .setPushExitAnimate({
            startTranslateOptions: { x: '0', y: '0' },
            endTranslateOptions: { x: '0', y: '100%' },
          })
        break
      case AnimConst.SCALE:
        // 缩放
        ZRouter.getInstance()
          .getAnimParamBuilder(this.modifier)
        ?.setPopEnterAnimate({
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
          .setPushExitAnimate({
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
          .getAnimParamBuilder(this.modifier)
        ?.setPopEnterAnimate({
          startOpacity: 0,
          endOpacity: 1,
        })
          .setPushExitAnimate({
            startOpacity: 1,
            endOpacity: 0,
          })
        break
      case AnimConst.ROTATE:
        // 旋转
        ZRouter.getInstance()
          .getAnimParamBuilder(this.modifier)
        ?.setPopEnterAnimate({
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
          .setPushExitAnimate({
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
          .getAnimParamBuilder(this.modifier)
        ?.setPopEnterAnimate({
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
          .setPushExitAnimate({
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
  }
}