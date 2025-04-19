/**
 * @author: HHBin
 * @date: 2024-11-5
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library'
import { Route, ZRouter } from 'routerapi'
import { AnimConst } from './AnimConst'

@Route({ name: RouterConstants.ANIM_DEMO })
@Component
export struct AnimTransitionDemo {

  build() {
    NavDestination() {
      Column({ space: 15 }) {
        Button("平移").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam(AnimConst.TRANSLATE)
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("平移-播放0.5S-减速播放").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam(AnimConst.ANIM)
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("缩放").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam(AnimConst.SCALE)
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("渐变").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam(AnimConst.OPACITY)
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("旋转").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam(AnimConst.ROTATE)
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("模糊").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam(AnimConst.BLUR)
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("组合").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("自定义").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.CUSTOM)
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("PageTwo").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .navigation(RouterConstants.PAGE_TWO)
        })
        Button('自己设置的全局转场').onClick(() => {
            ZRouter.getInstance().push(RouterConstants.PAGE_THREE)
          })
        Button('系统默认转场').onClick(() => {
            ZRouter.getInstance().push(RouterConstants.PAGE_FOUR)
          })
        Button("卡片一镜到底").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .navigation(RouterConstants.PAGE_CARD_ONE)
        })
      }

    }
    .width('100%')
    .height('100%')
    .title("自定义动画转场")
  }
}