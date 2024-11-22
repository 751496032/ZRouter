import { RouterConstants, ToastUtils } from 'common_library';
import { Route, ZRouter } from 'routerapi';
import LogUtil from 'routerapi/src/main/ets/utlis/LogUtil';


@Route({ name: RouterConstants.HARA_PAGE3 ,needLogin: true})
@Component
export struct Page3 {
  @State message: string = 'Hello World';

  aboutToAppear(): void {
    this.message = ZRouter.getInstance().getParam()?.toString() ?? ""
  }

  build() {
    NavDestination(){
      Column({space:12}){
        Text(this.message)
        Button('pushForResult - 监听上一页返回携带的数据').onClick((event: ClickEvent) => {
          // 上一个页面返回
          ZRouter.getInstance()
            .setParam('hello')
            .setPopListener((v)=>{
              ToastUtils.show(JSON.stringify(v.data))
            })
            .push(RouterConstants.HSPC_INDEX_PAGE)

        })

        Button('pushNavForResult - 监听跨多级页面返回携带的数据').onClick((event: ClickEvent) => {
          // 上上个页面返回
          ZRouter.getInstance()
            .setParam('hello')
            .enableCrossPageParamReturn()
            .setPopListener((r)=>{
                let msg = `from: ${r.from} data: ${r.data}`;
                this.message = msg
            })
            .push(RouterConstants.HARA_PAGE4)
        })


        Button('popToRootWithResult - 返回根视图并携带数据').onClick((event: ClickEvent) => {
          ZRouter.getInstance().popToRootWithResult<string>('哈哈')
        })

      }

    }
    .title('跳转携带参数与监听pop返回所携带的参数')
    .width('100%')
    .height('100%')

  }
}
