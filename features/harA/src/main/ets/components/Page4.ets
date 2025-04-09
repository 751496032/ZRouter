import { RouterConstants, ToastUtils } from 'common_library';
import { Route, ZRouter } from 'routerapi';


@Route({ name: RouterConstants.HARA_PAGE4 })
@Component
export struct Page4 {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){
        Button('toHarAPage5').onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setPopListener((result) => {
              ToastUtils.show('from: ' + result.from + '  data: ' + JSON.stringify(result.data))
            })
            .push(RouterConstants.PAGE_POP_CASE)
        })

      }

    }
    .title('harAPage4')
    .width('100%')
    .height('100%')

  }
}
