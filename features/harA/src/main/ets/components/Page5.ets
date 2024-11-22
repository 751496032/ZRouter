import { Route, ZRouter } from 'routerapi';
import systemTime from '@ohos.systemTime';
import { systemDateTime } from '@kit.BasicServicesKit';
import { RouterConstants } from 'common_library';


@Route({ name: RouterConstants.HARA_PAGE5 })
@Component
export struct Page5 {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){

        Button('popNavWithResult - 跨多级页面返回携带数据').onClick((event: ClickEvent) => {
          ZRouter.getInstance().popNavWithResult<string>(RouterConstants.HARA_PAGE3, 'result data 11 ' + systemDateTime.getTime())
        })

        Button('popToRootWithResult - 携带数据返回根视图').onClick((event: ClickEvent) => {
          ZRouter.getInstance().popToRootWithResult<string>('result data 22 ' + + systemDateTime.getTime())
        })

      }

    }
    .title('harAPage5')
    .width('100%')
    .height('100%')

  }
}
