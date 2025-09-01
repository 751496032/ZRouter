import { Route, ZRouter } from 'routerapi';
import systemTime from '@ohos.systemTime';
import { systemDateTime } from '@kit.BasicServicesKit';
import { RouterConstants } from 'common_library';


@Route({ name: RouterConstants.PAGE_POP_CASE,useTemplate:true,title:"pop案例" })
@Component
export struct PopCasePage5 {
  @State message: string = 'Hello World';

  build() {
    Column({space:12}){

      Text('popNavWithResult - 跨多级页面返回携带数据  已弃用 用popToNameWithResult替代')
        .onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .popNavWithResult<string>(RouterConstants.PAGE_PUSH_AND_POP_CASE,
              'popNavWithResult 跨多级页面返回携带数据 ' + systemDateTime.getTime())
        })
        .width('90%')
        .backgroundColor(Color.Red)
        .fontColor(Color.White)
        .padding(10)
        .borderRadius(40)

      Button('popToRootWithResult - 携带数据返回根视图').onClick((event: ClickEvent) => {
        ZRouter.getInstance().popToRootWithResult<string>('popToRootWithResult 携带数据返回根视图 '  + systemDateTime.getTime())
      })

      Button('pop - 返回上一页').onClick((event: ClickEvent) => {
        ZRouter.getInstance().pop()
      })

      Button('popWithResult - 空参数返回上一页').onClick((event: ClickEvent) => {
        ZRouter.getInstance().popWithResult()
      })


      Button('popWithResult - 携带参数返回上一页').onClick((event: ClickEvent) => {
        ZRouter.getInstance().popWithResult('popWithResult 携带参数返回上一页  ' + + systemDateTime.getTime())
      })

      Button('popToName - 返回指定页面').onClick((event: ClickEvent) => {
        ZRouter.getInstance().popToName(RouterConstants.PAGE_PUSH_AND_POP_CASE)
      })

      Button('popToNameWithResult - 空参数返回指定页面').onClick((event: ClickEvent) => {
        ZRouter.getInstance().popToNameWithResult(RouterConstants.PAGE_PUSH_AND_POP_CASE)
      })

      Button('popToNameWithResult - 携带参数返回指定页面').onClick((event: ClickEvent) => {
        ZRouter.getInstance().popToNameWithResult(RouterConstants.PAGE_PUSH_AND_POP_CASE, 'popToNameWithResult 携带参数返回指定页面  ' + systemDateTime.getTime())
      })

    }

  }
}
