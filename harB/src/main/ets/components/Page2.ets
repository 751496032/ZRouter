import { Route } from '@hzw/zrouter/src/main/ets/annotation/Route';
import { ZRouter } from '@hzw/zrouter/src/main/ets/api/Router';


@Route({name:'harBPage2'})
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

        Button('pop').onClick((event: ClickEvent) => {
          ZRouter.pop()
        })

        Button('clear').onClick((event: ClickEvent) => {
          ZRouter.clear()
        })
      }

    }
    .title('harBPage2')
    .width('100%')
    .height('100%')

  }
}
