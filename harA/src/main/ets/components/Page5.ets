import { Route, ZRouter } from 'routerapi';


@Route({ name: "harAPage5" })
@Component
export struct Page5 {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){

        Button('popNavWithResult').onClick((event: ClickEvent) => {
          ZRouter.popNavWithResult<string>('harAPage3', 'result data')
        })

      }

    }
    .title('harAPage5')
    .width('100%')
    .height('100%')

  }
}
