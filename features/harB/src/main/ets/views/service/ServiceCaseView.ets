import { IHarAService, IHspCService, RouterConstants, ToastUtils } from 'common_library';
import { Route, ZRouter } from 'routerapi';

/**
 * @author: HZWei
 * @date: 2024/11/7
 * @desc:  服务路由案例
 */

@Route({ name: RouterConstants.SERVICE_CASE_VIEW })
@Component
export struct ServiceCaseView {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){
        Text('当前在harB模块')
          .fontSize(20)
        Button('模块间通信-调用harA模块的异步方法').onClick((event: ClickEvent) => {
          ZRouter.getService<IHarAService>(RouterConstants.SERVICE_HARA_IMPL)?.getUserInfo().then((r)=>{
            ToastUtils.show("来自harA的数据： " + r)
          })
        })

        Button('模块间通信-调用harA模块的同步方法').onClick((event: ClickEvent) => {
          ZRouter.getService<IHarAService>(RouterConstants.SERVICE_HARA_IMPL)?.showToast("hello ZRouter!")
        })

        Button('模块间通信-调用hspC模块的异步方法').onClick((event: ClickEvent) => {
          ZRouter.getService<IHspCService>(RouterConstants.SERVICE_HSPC_IMPL)?.getDataFromHspC().then((r) => {
            ToastUtils.show(r)
          })
        })
      }

    }
    .title('服务路由-实现模块通信')
    .width('100%')
    .height('100%')

  }
}
