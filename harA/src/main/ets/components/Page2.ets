import { Route, ZRouter } from 'routerapi';

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
          ZRouter.getInstance().push("harAPage1")
        })

        Button('toHarAPage2').onClick((event: ClickEvent) => {
          ZRouter.getInstance().push("harAPage2")
        })

        Button('toHarBPage1').onClick((event: ClickEvent) => {
          ZRouter.getInstance().push("harBPage1")
        })

        Button('toHarBPage2').onClick((event: ClickEvent) => {
          ZRouter.getInstance().push("harBPage2")
        })
      }

    }
    .title('harAPage2')
    .width('100%')
    .height('100%')

  }
}
