import { Route, ZRouter } from 'routerapi';


@Route({ name: 'hspCPage1', needLogin:true ,extra: 'hsp'})
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

        Button('toHspCPage1').onClick((event: ClickEvent) => {
          ZRouter.push("hspCPage1")
        })

        Button('toHspCPage2').onClick((event: ClickEvent) => {
          ZRouter.push("hspCPage2")
        })
      }

    }
    .title('hspCPage1')
    .width('100%')
    .height('100%')

  }
}
