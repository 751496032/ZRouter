/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import {
  NavAnimateOptions,
  OpacityAnimateOptions,
  RotateAnimateOptions,
  Route,
  ScaleAnimateOptions,
  TranslateAnimationOptions,
  ZRouter
} from 'routerapi';
import { AnimateCallback } from 'routerapi/src/main/ets/animation/NavAnimationMgr';
import { AnimConst } from './AnimConst';

@Builder
export function PageOneBuilder(name: string, param: Object) {
  PageOne()
}

@Route({ name: RouterConstants.PAGE_ONE })
@Component
export struct PageOne {
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
            .animateMgr()
            .registerAnimParam(this, context)
            .addAnimateOptions(new TranslateAnimationOptions({ y: '100%' }))
          break
        case AnimConst.ANIM:
          // 平移-播放0.5-减速播放
          ZRouter.getInstance()
            .animateMgr()
            .registerAnimParam(this, context)
            .setEnterAnimate({ duration: 500, curve: Curve.LinearOutSlowIn })
            .setExitAnimate({ duration: 500, curve: Curve.LinearOutSlowIn })
            .addAnimateOptions(new TranslateAnimationOptions({ y: '100%' }))
          break
        case AnimConst.SCALE:
          // 缩放
          ZRouter.getInstance()
            .animateMgr()
            .registerAnimParam(this, context)
            .addAnimateOptions(new ScaleAnimateOptions({
              x: 0,
              y: 0,
              centerX: 0,
              centerY: 0
            }))
          break
        case AnimConst.OPACITY:
          // 渐变
          ZRouter.getInstance()
            .animateMgr()
            .registerAnimParam(this, context)
            .addAnimateOptions(new OpacityAnimateOptions(0.01))
          break
        case AnimConst.ROTATE:
          // 旋转
          ZRouter.getInstance()
            .animateMgr()
            .registerAnimParam(this, context)
            .addAnimateOptions(new RotateAnimateOptions({
              angle: 90,
              x: 1,
              y: 1,
              z: 1,
              centerX: 0,
              centerY: 0
            }))
          break
        case AnimConst.CUSTOM:
          // 自定义
          ZRouter.getInstance()
            .animateMgr()
            .registerAnimParam(this, context)
            .setCustomAnimeOptions(new CustomAnimOptions())
          break
        default:
        // 组合
          ZRouter.getInstance()
            .animateMgr()
            .registerAnimParam(this, context)
            .addAnimateOptions(new TranslateAnimationOptions({ y: '100%' }))
            .addAnimateOptions(new ScaleAnimateOptions({ x: 0, y: 0 }))
            .addAnimateOptions(new OpacityAnimateOptions(0.01))
            .addAnimateOptions(new RotateAnimateOptions({ angle: 90 }))
      }
    })
    .onDisAppear(() => {
      ZRouter.getInstance().animateMgr().unregisterAnim(this)
    })
    .attributeModifier(ZRouter.getInstance().animateMgr().modifier(this))
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

// 自定义转场
class CustomAnimOptions extends NavAnimateOptions {
  public update(callback: AnimateCallback): void {
    // 进场
    callback.pushEnterParam = {
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
    }
    // 退场
    callback.popExitParam = {
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
    }
  }
}