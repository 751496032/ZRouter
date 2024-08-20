import { Route, ZRouter } from 'routerapi';
import systemTime from '@ohos.systemTime';
import { systemDateTime } from '@kit.BasicServicesKit';


@Route({ name: "harAPage5" })
@Component
export struct Page5 {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){

        Button('popNavWithResult').onClick((event: ClickEvent) => {
          ZRouter.popNavWithResult<string>('harAPage3', 'result data 11 ' + systemDateTime.getTime())
        })

        Button('popRoot').onClick((event: ClickEvent) => {
          ZRouter.popToRootWithResult<string>('result data 22 ' + + systemDateTime.getTime())
        })

      }

    }
    .title('harAPage5')
    .width('100%')
    .height('100%')

  }
}
