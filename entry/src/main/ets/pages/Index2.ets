/**
 * @author: HZWei
 * @date: 2024/9/17
 * @desc:
 */
import { ZRouter } from 'routerapi'

const NAV_STACK_NAME = "newNavStack"

@Component
@Entry
export struct Index2 {
  @Provide stack: NavPathStack = new NavPathStack()
  @State msg: string = "hello world"

  aboutToAppear(): void {
    // 在合适的时机注册导航栈
    let s = ZRouter.getNavStackByName(NAV_STACK_NAME)
    ZRouter.registerNavStack(NAV_STACK_NAME, this.stack)
  }

  build() {
    Navigation(this.stack) {
      Column({ space: 15 }) {
        Text(this.msg)
        Button("EmptyPage").onClick((event: ClickEvent) => {
          ZRouter.getInstance(NAV_STACK_NAME).push("PageNotFound")
        })

        Button("harAMainPage").onClick((event: ClickEvent) => {
          ZRouter.getInstance(NAV_STACK_NAME)
            .setAnimate(true)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation("harAMainPage")
        })
      }

    }
    .width('100%')
    .height('100%')
  }
}