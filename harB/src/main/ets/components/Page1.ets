import { Route } from 'routerapi/src/main/ets/annotation/Route';
import { ZRouter } from 'routerapi/src/main/ets/api/Router';

class Test{
    static harBPage1:string ="harBPage1";
}
@Route({ name: 'harBPage1', needLogin:true})
@Component
export struct Page1 {
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
    .title('harBPage1')
    .width('100%')
    .height('100%')

  }
}
