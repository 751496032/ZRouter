import { promptAction } from '@kit.ArkUI';
import { IHarAService, IHspCService, RouterConstants } from 'common_library';
import { Route, ZRouter } from 'routerapi';
import { ObjectOrNull } from 'routerapi/src/main/ets/model/Model';


@Route({ name: RouterConstants.HARB_MAIN_PAGE })
@Component
export struct MainPage {
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

        Button('toHspCIndex(测试跳转与返回携带数据)').onClick((event: ClickEvent) => {
          // ZRouter.push("hspCIndex")
          let data: Record<string, ObjectOrNull> = { 'msg': 'hello' }
          ZRouter.pushForResult("hspCIndex", data, (data) => {
            promptAction.showDialog({ message: `返回携带的数据：${JSON.stringify(data.result)}` })
          })
        })

        Button('模块间通信-调用harA模块的异步方法').onClick((event: ClickEvent) => {
          ZRouter.getService<IHarAService>(RouterConstants.SERVICE_HARA_IMPL)?.getUserInfo().then((r)=>{
            console.log("调用harA模块的异步方法:  ", r)
            promptAction.showToast({ message: "来自harA的数据： " + r })
          })
        })

        Button('模块间通信-调用harA模块的同步方法').onClick((event: ClickEvent) => {
          ZRouter.getService<IHarAService>(RouterConstants.SERVICE_HARA_IMPL)?.showToast("hello ZRouter!")
        })

        Button('模块间通信-调用hspC模块的异步方法').onClick((event: ClickEvent) => {
          ZRouter.getService<IHspCService>(RouterConstants.SERVICE_HSPC_IMPL)?.getDataFromHspC().then((r) => {
            promptAction.showToast({ message: r })
          })
        })
      }

    }
    .title('harBMainPage')
    .width('100%')
    .height('100%')

  }
}
