/**
 * @author: HZWei
 * @date: 2024/9/17
 * @desc:
 */
import { ZRouter } from 'routerapi'
const NAV_STACK_NAME = "test"

@Component
@Entry
export struct NavIndex {
  build() {
    Navigation(ZRouter.getNavStackByName(NAV_STACK_NAME)){

      Column({space:15}){
        Button("EmptyPage").onClick((event: ClickEvent) => {
          ZRouter.push("PageNotFound")
        })

        Button("harAMainPage").onClick((event: ClickEvent) => {
          ZRouter.getNavStackByName(NAV_STACK_NAME).pushPathByName("harAMainPage",null)
        })
      }

    }
    .width('100%')
    .height('100%')
  }
}