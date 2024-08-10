import { promptAction } from '@kit.ArkUI';
import { Route, ZRouter } from 'routerapi';
import { ObjectOrNull } from 'routerapi/src/main/ets/model/Model';


@Route({name:'harBMainPage'})
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

        Button('toHspCIndex(测试跳转与返回携带数据)').onClick((event: ClickEvent) => {
          // ZRouter.push("hspCIndex")
          let data: Record<string, ObjectOrNull> = { 'msg': 'hello' }
          ZRouter.pushForResult("hspCIndex", data, (data) => {
            promptAction.showDialog({ message: `返回携带的数据：${JSON.stringify(data.result)}` })
          })
        })
      }

    }
    .title('harBMainPage')
    .width('100%')
    .height('100%')

  }
}
