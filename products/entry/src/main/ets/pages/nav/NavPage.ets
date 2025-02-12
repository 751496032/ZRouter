/**
 * @author: HZWei
 * @date: 2024/11/7
 * @desc:  模拟第三方Navigation实例使用ZRouter库的Api
 */

import { RouterConstants } from "@hzw/common_library"
import { ZRouter } from "routerapi"


const NAV_STACK_NAME = "newNavStack"

@Component
@Entry
export struct NavPage {
  @Provide stack: NavPathStack = new NavPathStack()
  @State msg: string = "hello world"

  aboutToAppear(): void {
    // 在合适的时机注册路由栈实例
    ZRouter.registerNavStack(NAV_STACK_NAME, this.stack)
  }

  aboutToDisappear(): void {
    ZRouter.unregisterNavStack(NAV_STACK_NAME)
  }

  build() {
    Navigation(this.stack) {
      Column({ space: 15 }) {
        Text(this.msg)
        Button("EmptyPage").onClick((event: ClickEvent) => {
          ZRouter.getInstance().push("PageNotFound")
        })

        Button(RouterConstants.HARA_MAIN_PAGE).onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setAnimate(true)
            .setPopListener((v) => {
              this.msg = v.data?.toString() + ' ' + v.from?.toString()
            })
            .navigation(RouterConstants.HARA_MAIN_PAGE)
        })
      }

    }
    .width('100%')
    .height('100%')
  }
}