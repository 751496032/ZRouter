/**
 * @author: HHBin
 * @date: 2024-11-5
 * @desc:
 */
import { ZRouter } from 'routerapi'
import { AnimConst } from './AnimConst'

@Entry
@Component
export struct AnimTransitionDemo {
  @State msg: string = "自定义动画转场"

  build() {
    Navigation(ZRouter.getNavStack()) {
      Column({ space: 15 }) {
        Text(this.msg)
        Button("平移").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.TRANSLATE)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("PageOne")
        })
        Button("平移-延迟1S-播放2S-减速播放").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.ANIM)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("PageOne")
        })
        Button("缩放").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.SCALE)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("PageOne")
        })
        Button("渐变").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.OPACITY)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("PageOne")
        })
        Button("旋转").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.ROTATE)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("PageOne")
        })
        Button("组合").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("PageOne")
        })
        Button("自定义").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setParam(AnimConst.CUSTOM)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("PageOne")
        })
        Button("上一个页面的退场/进场动画").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("PageTwo")
        })
      }

    }
    .width('100%')
    .height('100%')
    .title("自定义动画转场")
    .customNavContentTransition(ZRouter.getInstance().getAnimCustomNavContentTransition())
  }
}