import { Route } from '@hzw/zrouter/src/main/ets/annotation/Route';
import { ZRouter } from '@hzw/zrouter/src/main/ets/api/Router';

/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */


@Route({ name: "harAPage2",description:"测试" })
@Component
export struct Page2 {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){
        Button('toHarAPage1').onClick((event: ClickEvent) => {
          ZRouter.push("harAPage1")
        })

        Button('toHarAPage2').onClick((event: ClickEvent) => {
          ZRouter.push("harAPage2")
        })

        Button('toHarBPage1').onClick((event: ClickEvent) => {
          ZRouter.push("harBPage1")
        })

        Button('toHarBPage2').onClick((event: ClickEvent) => {
          ZRouter.push("harBPage2")
        })
      }

    }
    .title('harAPage1')
    .width('100%')
    .height('100%')

  }
}
