/**
 * @author: HHBin
 * @date: 2024-11-5
 * @desc:
 */
import { ZRouter } from 'routerapi'

@Entry
@Component
export struct AnimTransitionDemo {
  @State msg: string = "自定义动画转场"

  build() {
    Navigation(ZRouter.getNavStack()) {
      Column({ space: 15 }) {
        Text(this.msg)
        Button("PageOne").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setAnimationOptions({})
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("PageOne")
        })
        Button("PageTwo").onClick((event: ClickEvent) => {
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
    .title("asd")
    .customNavContentTransition(ZRouter.getInstance().getAnimCustomNavContentTransition())
  }
}