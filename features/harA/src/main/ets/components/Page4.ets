import { RouterConstants } from 'common_library';
import { Route, ZRouter } from 'routerapi';


@Route({ name: RouterConstants.HARA_PAGE4 })
@Component
export struct Page4 {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){
        Button('toHarAPage5').onClick((event: ClickEvent) => {
          ZRouter.push(RouterConstants.HARA_PAGE5)
        })

      }

    }
    .title('harAPage4')
    .width('100%')
    .height('100%')

  }
}
