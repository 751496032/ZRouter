import { promptAction } from '@kit.ArkUI';
import { IHarAService, IHspCService, RouterConstants } from 'common_library';
import { Route, ZRouter } from 'routerapi';
import { ObjectOrNull } from 'routerapi/src/main/ets/model/Model';


@Route({ name: RouterConstants.HARB_MAIN_PAGE })
@Component
export struct MainPage {
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
    .title('harBMainPage')
    .width('100%')
    .height('100%')

  }
}
