/**
 * @author: HZWei
 * @date: 2024/9/17
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library'
import { ZRouter } from 'routerapi'
import { RouterConst } from '../../constants/RouterConst'

const NAV_STACK_NAME = "newNavStack"

@Component
@Entry({routeName:RouterConst.INDEX2_NAME})
export struct Index2 {
  @Provide stack: NavPathStack = new NavPathStack()
  @State msg: string = "hello world"

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
        Button("EmptyPage").onClick((event: ClickEvent) => {
          ZRouter.getInstance(NAV_STACK_NAME).push("PageNotFound")
        })

        Button(RouterConstants.HARA_MAIN_PAGE).onClick((event: ClickEvent) => {
          ZRouter.getInstance(NAV_STACK_NAME)
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