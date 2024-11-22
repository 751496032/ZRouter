/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import { NavAnimationModifier, Route, ZRouter } from 'routerapi';
import { AnimConst } from './AnimConst';

@Builder
export function PageOneBuilder(name: string, param: Object) {
  PageOne()
}

@Route({ name: RouterConstants.PAGE_ONE })
@Component
export struct PageOne {
  modifier: NavAnimationModifier = new NavAnimationModifier()
  rectWidth: number = 0;
  interactive: boolean = false;

  build() {
    NavDestination() {
      Column() {
        Button('自己设置的全局转场', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            ZRouter.getInstance().push(RouterConstants.PAGE_THREE)
          })
        Button('系统默认转场', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            ZRouter.getInstance().push(RouterConstants.PAGE_FOUR)
          })
        Button('上一页的退场/进场动画', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            ZRouter.getInstance().push(RouterConstants.PAGE_TWO)
          })
        Button('DialogMode', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            ZRouter.getInstance().push(RouterConstants.PAGE_DIALOG_MODE)
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('PageOne')
    .onReady((context: NavDestinationContext) => {
      switch (ZRouter.getParam()) {
        case AnimConst.TRANSLATE:
          // 平移
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
              startCallback: (m) => {
                m.attribute?.translate({ x: '100%', y: '100%' })
              },
              endCallback: (m) => {
                m.attribute?.translate({ x: '0', y: '0' })
              },
            })
            .setPopExitAnimate({
              startCallback: (m) => {
                m.attribute?.translate({ x: '0', y: '0' })
              },
              endCallback: (m) => {
                m.attribute?.translate({ x: '0', y: '100%' })
              },
            })
          break
        case AnimConst.ANIM:
          // 平移-播放0.5-减速播放
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
              animateParam: {
                duration: 500,
                curve: Curve.LinearOutSlowIn
              },
              startCallback: (m) => {
                m.attribute?.translate({ x: '100%', y: '100%' })
              },
              endCallback: (m) => {
                m.attribute?.translate({ x: '0', y: '0' })
              },
            })
            .setPopExitAnimate({
              animateParam: {
                duration: 500,
                curve: Curve.LinearOutSlowIn
              },
              startCallback: (m) => {
                m.attribute?.translate({ x: '0', y: '0' })
              },
              endCallback: (m) => {
                m.attribute?.translate({ x: '100%', y: '100%' })
              },
            })
          break
        case AnimConst.SCALE:
          // 缩放
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
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
            .setPopExitAnimate({
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
              }
            })
          break
        case AnimConst.OPACITY:
          // 渐变
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
              startCallback: (m) => {
                m.attribute?.opacity(0.01)
              },
              endCallback: (m) => {
                m.attribute?.opacity(1)
              },
            })
            .setPopExitAnimate({
              startCallback: (m) => {
                m.attribute?.opacity(1)
              },
              endCallback: (m) => {
                m.attribute?.opacity(0.01)
              },
            })
          break
        case AnimConst.CUSTOM:
          // 自定义
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
              startCallback: (m, proxy) => {
                m.attribute?.translate({ x: '100%' }).rotate({ angle: 90 }).opacity(0.1)
                animateTo({
                  onFinish: () => {
                    animateTo({
                      onFinish: () => {
                        proxy?.finishTransition()
                      }
                    }, () => {
                      m.attribute?.translate({ x: '0' }).opacity(1)
                    })
                  }
                }, () => {
                  m.attribute?.translate({ x: '50%' }).rotate({ angle: 0 }).opacity(0.7)
                })
              }
            })
            .setPopExitAnimate({
              startCallback: (m, proxy) => {
                m.attribute?.translate({ x: '0' }).opacity(1)
                animateTo({
                  onFinish: () => {
                    animateTo({
                      onFinish: () => {
                        proxy?.finishTransition()
                      }
                    }, () => {
                      m.attribute?.translate({ x: '100%' }).rotate({ angle: 90 }).opacity(0.1)
                    })
                  }
                }, () => {
                  m.attribute?.translate({ x: '50%' }).rotate({ angle: 0 }).opacity(0.7)
                })
              }
            })
          break
        default:
        // 组合
          ZRouter.getInstance()
            .registerAnimParam(this.modifier, context)
            .setPushEnterAnimate({
              startCallback: (m) => {
                m.attribute?.translate({ x: '100%', y: '0' })
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
            .setPopExitAnimate({
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
                m.attribute?.translate({ x: '0', y: '0' })
                  .scale({
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