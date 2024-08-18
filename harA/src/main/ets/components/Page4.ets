import { Route, ZRouter } from 'routerapi';


@Route({ name: "harAPage4" })
@Component
export struct Page4 {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){

        Button('toHarAPage5').onClick((event: ClickEvent) => {
          ZRouter.push("harAPage5")
        })

      }

    }
    .title('harAPage4')
    .width('100%')
    .height('100%')

  }
}
