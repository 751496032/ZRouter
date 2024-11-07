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
        Button('pushForResult').onClick((event: ClickEvent) => {
          // 上一个页面返回
          ZRouter.getInstance()
            .setParam('hello')
            .setPopListener((v)=>{
              ToastUtils.show(JSON.stringify(v.data))
            })
            .push("hspCIndex")

        })

        Button('pushNavForResult').onClick((event: ClickEvent) => {
          // 上上个页面返回
          ZRouter.getInstance()
            .setParam('hello')
            .enableCrossPageParamReturn()
            .setPopListener((r)=>{
                let msg = `from: ${r.from} data: ${r.data}`;
                this.message = msg
            })
            .push("harAPage4")
        })

        Button('toHspCIndex(测试跳转与返回携带数据)').onClick((event: ClickEvent) => {
          let data: Record<string, Object> = { 'msg': 'hello' }
          ZRouter.pushForResult("hspCIndex", data, (data) => {
            ToastUtils.show(`返回携带的数据：${JSON.stringify(data.result)}`)
          })
        })

        Button('popToRootWithResult').onClick((event: ClickEvent) => {
          ZRouter.getInstance().popToRootWithResult<string>('哈哈')
        })

      }

    }
    .title('跳转携带参数与监听pop返回所携带的参数')
    .width('100%')
    .height('100%')

  }
}
