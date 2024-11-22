/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import { NavAnimationModifier, Route, ZRouter } from 'routerapi';
import { AnimConst } from './AnimConst';

@Builder
export function PageTwoBuilder(name: string, param: Object) {
  PageTwo()
}

@Route({ name: RouterConstants.PAGE_TWO })
@Component
export struct PageTwo {
  modifier: NavAnimationModifier = new NavAnimationModifier()
  @State jumpIndex: number = 0

  build() {
    NavDestination() {
      Column({ space: 15 }) {
        Text('进入新页面时，该页面的退场动画' +
          '\n新页面退出时，该页面的进场动画' +
          '\n如果下一页无转场，则默认系统转场，当前转场效果不生效')
        Text(this.jumpText())
          .fontSize(21)
          .fontColor(Color.Black)
          .fontWeight(10)
        Button("切换跳转页面").backgroundColor(Color.Orange).onClick((event: ClickEvent) => {
          this.jumpIndex++
        })
        Button("平移").onClick((event: ClickEvent) => {
          this.setAnim(AnimConst.TRANSLATE)
          this.jump()
        })
        Button("缩放").onClick((event: ClickEvent) => {
          this.setAnim(AnimConst.SCALE)
          this.jump()
        })
        Button("渐变").onClick((event: ClickEvent) => {
          this.setAnim(AnimConst.OPACITY)
          this.jump()
        })
        Button("旋转").onClick((event: ClickEvent) => {
          this.setAnim(AnimConst.ROTATE)
          this.jump()
        })
        Button("组合").onClick((event: ClickEvent) => {
          this.setAnim("")
          this.jump()
        })
        Button('PageTwo进场/退场动画+PageOne进场/退场动画', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.setAnim("")
            this.jump()
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('pageTwo')
    .onReady((context: NavDestinationContext) => {
      ZRouter.getInstance().registerAnimParam(this.modifier, context)
        .setPushEnterAnimate({
          startCallback: (m) => {
            m.attribute?.size({ width: '50%' }).opacity(0.5)
          },
          endCallback: (m) => {
            m.attribute?.size({ width: '100%' }).opacity(1)
          },
        })
        .setPopExitAnimate({
          startCallback: (m) => {
            m.attribute?.size({ width: '100%' }).opacity(1)
          },
          endCallback: (m) => {
            m.attribute?.size({ width: '50%' }).opacity(0.5)
          },
        })
    })
    .onDisAppear(() => {
      ZRouter.getInstance().unregisterAnim(this.modifier)
    })
    .attributeModifier(this.modifier)
    .backgroundColor(Color.Yellow)
  }

  private jumpText() {
    switch (this.jumpIndex % 4) {
      case 1:
        return "跳PageTwo"
      case 2:
        return "跳自己设置的全局转场"
      case 3:
        return "跳系统默认转场"
      default:
        return "跳PageOne"
    }
  }

  private jump() {
    switch (this.jumpIndex % 4) {
      case 1:
        ZRouter.getInstance().navigation(RouterConstants.PAGE_TWO)
        break
      case 2:
        ZRouter.getInstance().navigation(RouterConstants.PAGE_THREE)
        break
      case 3:
        ZRouter.getInstance().navigation(RouterConstants.PAGE_FOUR)
        break
      default:
        ZRouter.getInstance()
          .setParam(AnimConst.TRANSLATE)
          .navigation(RouterConstants.PAGE_ONE)
    }
  }

  private setAnim(type: string) {
    switch (type) {
      case AnimConst.TRANSLATE:
        // 平移
        ZRouter.getInstance().getAnimParamBuilder(this.modifier)
        ?.setPopEnterAnimate({
          startCallback: (m) => {
            m.attribute?.translate({ x: '100%', y: '100%' })
          },
          endCallback: (m) => {
            m.attribute?.translate({ x: '0', y: '0' })
          },
        })
          .setPushExitAnimate({
            startCallback: (m) => {
              m.attribute?.translate({ x: '0', y: '0' })
            },
            endCallback: (m) => {
              m.attribute?.translate({ x: '0', y: '100%' })
            },
          })
        break
      case AnimConst.SCALE:
        // 缩放
        ZRouter.getInstance().getAnimParamBuilder(this.modifier)
        ?.setPopEnterAnimate({
          startCallback: (m) => {
            m.attribute?.scale({
              x: 0,
              y: 0,
              centerX: '50%',
              centerY: '50%',
            })
          },
          endCallback: (m) => {
            m.attribute?.scale({
              x: 1,
              y: 1,
              centerX: '50%',
              centerY: '50%',
            })
          },
        })
          .setPushExitAnimate({
            startCallback: (m) => {
              m.attribute?.scale({
                x: 1,
                y: 1,
                centerX: '0',
                centerY: '0',
              })
            },
            endCallback: (m) => {
              m.attribute?.scale({
                x: 0,
                y: 0,
                centerX: '0',
                centerY: '0',
              })
            },
          })
        break
      case AnimConst.OPACITY:
        // 渐变
        ZRouter.getInstance().getAnimParamBuilder(this.modifier)
        ?.setPopEnterAnimate({
          startCallback: (m) => {
            m.attribute?.opacity(0.01)
          },
          endCallback: (m) => {
            m.attribute?.opacity(1)
          },
        })
          .setPushExitAnimate({
            startCallback: (m) => {
              m.attribute?.opacity(1)
            },
            endCallback: (m) => {
              m.attribute?.opacity(0.01)
            },
          })
        break
      case AnimConst.ROTATE:
        // 旋转
        ZRouter.getInstance().getAnimParamBuilder(this.modifier)
        ?.setPopEnterAnimate({
          startCallback: (m) => {
            m.attribute?.rotate({
              angle: -90,
              centerX: '0',
              centerY: '100%',
            })
          },
          endCallback: (m) => {
            m.attribute?.rotate({
              angle: 0,
              centerX: '100%',
              centerY: '100%',
            })
          },
        })
          .setPushExitAnimate({
            startCallback: (m) => {
              m.attribute?.rotate({
                angle: 0,
                centerX: '100%',
                centerY: '100%',
              })
            },
            endCallback: (m) => {
              m.attribute?.rotate({
                angle: -90,
                centerX: '0',
                centerY: '100%',
              })
            },
          })
        break
      default:
      // 组合
        ZRouter.getInstance().getAnimParamBuilder(this.modifier)
        ?.setPopEnterAnimate({
          startCallback: (m) => {
            m.attribute?.translate({ x: '100%', y: '100%' })
              .scale({
                x: 0,
                y: 0,
                centerX: '50%',
                centerY: '50%',
              })
              .opacity(0.01)
              .rotate({
                angle: 90,
                centerX: '50%',
                centerY: '50%',
              })
          },
          endCallback: (m) => {
            m.attribute?.translate({ x: '0', y: '0' })
              .scale({
                x: 1,
                y: 1,
                centerX: '50%',
                centerY: '50%',
              })
              .opacity(1)
              .rotate({
                angle: 0,
                centerX: '50%',
                centerY: '50%',
              })
          },
        })
          .setPushExitAnimate({
            startCallback: (m) => {
              m.attribute?.scale({
                x: 1,
                y: 1,
                centerX: '50%',
                centerY: '50%',
              })
                .opacity(1)
                .rotate({
                  angle: 0,
                  centerX: '100%',
                  centerY: '100%',
                })
            },
            endCallback: (m) => {
              m.attribute?.scale({
                x: 0,
                y: 0,
                centerX: '0',
                centerY: '0',
              })
                .opacity(0.01)
                .rotate({
                  angle: 360,
                  centerX: '50%',
                  centerY: '50%',
                })
            },
          })
    }
  }
}