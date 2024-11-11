/**
 * @author: HHBin
 * @date: 2024-11-5
 * @desc:
 */
import { Route, ZRouter } from 'routerapi'
import { AnimateCallback, CustomTransition } from 'routerapi/src/main/ets/model/AnimationUtils'

export const NAV_STACK_NAME = "newNavStackAnim"

@Entry
@Component
export struct AnimTransitionDemo {
  @Provide stack: NavPathStack = new NavPathStack()
  @State msg: string = "自定义动画转场"

  aboutToAppear(): void {
    // 在合适的时机注册导航栈
    // let s = ZRouter.getNavStackByName(NAV_STACK_NAME)
    ZRouter.registerNavStack(NAV_STACK_NAME, this.stack)
  }

  aboutToDisappear(): void {
    ZRouter.unregisterNavStack(NAV_STACK_NAME)
  }

  build() {
    Navigation(this.stack) {
      Column({ space: 15 }) {
        Text(this.msg)
        Button("PageOne").onClick((event: ClickEvent) => {
          ZRouter.getInstance(NAV_STACK_NAME)
            .setAnimate(true)
            .setAnimationOptions({})
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("PageOne")
        })
        Button("PageTwo").onClick((event: ClickEvent) => {
          ZRouter.getInstance(NAV_STACK_NAME)
            .setAnimate(true)
            .setAnimationOptions({})
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
    .customNavContentTransition(ZRouter.getInstance(NAV_STACK_NAME).getAnimCustomNavContentTransition())
  }
}