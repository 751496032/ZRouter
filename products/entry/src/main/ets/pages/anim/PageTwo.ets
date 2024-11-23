/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import {
  OpacityAnimateOptions,
  RotateAnimateOptions,
  Route,
  ScaleAnimateOptions,
  TranslateAnimationOptions,
  ZRouter
} from 'routerapi';
import { AnimConst } from './AnimConst';

@Builder
export function PageTwoBuilder(name: string, param: Object) {
  PageTwo()
}

@Route({ name: RouterConstants.PAGE_TWO })
@Component
export struct PageTwo {
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

        Button(RouterConstants.HSPC_PAGE3).onClick((event: ClickEvent) => {
          ZRouter.getInstance().push(RouterConstants.HSPC_PAGE3)
        })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('pageTwo')
    .onReady((context: NavDestinationContext) => {
      ZRouter.getInstance()
        .animateMgr()
        .registerAnimParam(this, context)
    })
    .onDisAppear(() => {
      ZRouter.getInstance().animateMgr().unregisterAnim(this)
    })
    .attributeModifier(ZRouter.getInstance().animateMgr().modifier(this))
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
        ZRouter.getInstance().animateMgr().getAnimParamBuilder(this)
        ?.addAnimateOptions(new TranslateAnimationOptions({ y: '100%' }, true))
        break
      case AnimConst.SCALE:
        // 缩放
        ZRouter.getInstance().animateMgr().getAnimParamBuilder(this)
        ?.addAnimateOptions(new ScaleAnimateOptions({ x: 0, y: 0 }, true))
        break
      case AnimConst.OPACITY:
        // 渐变
        ZRouter.getInstance().animateMgr().getAnimParamBuilder(this)
        ?.addAnimateOptions(new OpacityAnimateOptions(0.01, true))
        break
      case AnimConst.ROTATE:
        // 旋转
        ZRouter.getInstance().animateMgr().getAnimParamBuilder(this)
        ?.addAnimateOptions(new RotateAnimateOptions({ angle: 90 }, true))
        break
      default:
      // 组合
        ZRouter.getInstance().animateMgr().getAnimParamBuilder(this)
        ?.addAnimateOptions(new TranslateAnimationOptions({ y: '100%' }, true))
          .addAnimateOptions(new ScaleAnimateOptions({ x: 0, y: 0 }, true))
          .addAnimateOptions(new RotateAnimateOptions({ angle: 90 }, true))
          .addAnimateOptions(new RotateAnimateOptions({ angle: 90 }, true))
    }
  }
}