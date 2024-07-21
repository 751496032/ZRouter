import { Route } from 'routerapi/src/main/ets/annotation/Route';
import { ZRouter } from 'routerapi/src/main/ets/api/Router';

@Route({name:'hspCPage2'})
@Component
export struct Page2 {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){

        Button('pop').onClick((event: ClickEvent) => {
          ZRouter.pop()
        })

        Button('clear').onClick((event: ClickEvent) => {
          ZRouter.clear()
        })
      }

    }
    .title('harCPage2')
    .width('100%')
    .height('100%')

  }
}
