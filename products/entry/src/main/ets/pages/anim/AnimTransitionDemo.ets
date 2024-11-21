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
  @State msg: string = "自定义动画转场"

  build() {
    NavDestination() {
      Column({ space: 15 }) {
        Text(this.msg)
        Button("平移").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.TRANSLATE)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("平移-播放2S-减速播放").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.ANIM)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("缩放").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.SCALE)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("渐变").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.OPACITY)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("旋转").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.ROTATE)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("组合").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("自定义").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.CUSTOM)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation(RouterConstants.PAGE_ONE)
        })
        Button("上一页的退场/进场动画").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation(RouterConstants.PAGE_TWO)
        })
      }

    }
    .width('100%')
    .height('100%')
    .title("自定义动画转场")
  }
}