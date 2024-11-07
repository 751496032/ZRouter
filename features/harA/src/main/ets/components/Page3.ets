import { Route, ZRouter } from 'routerapi';
import LogUtil from 'routerapi/src/main/ets/utlis/LogUtil';


@Route({ name: "harAPage3" ,needLogin: true})
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
          // ZRouter.pushForResult("hspCIndex", 'hello', (data) => {
          //   AlertDialog.show({ message: JSON.stringify(data.result) })
          // })


          ZRouter.getInstance()
            .setParam('hello')
            .setPopListener((v)=>{
                AlertDialog.show({ message: JSON.stringify(v.data) })
            })
            .push("hspCIndex")

        })

        Button('pushNavForResult').onClick((event: ClickEvent) => {
          // 上上个页面返回
          // ZRouter.pushNavForResult<string>("harAPage4", 'hello', (r) => {
          //   let msg = `from: ${r.from} data: ${r.data}`;
          //   this.message = msg
          //   LogUtil.log(msg);
          // })

          ZRouter.getInstance()
            .setParam('hello')
            .enableCrossPageParamReturn()
            .setPopListener((r)=>{
                let msg = `from: ${r.from} data: ${r.data}`;
                this.message = msg
            })
            .push("harAPage4")
        })

        Button('popToRootWithResult').onClick((event: ClickEvent) => {
          // ZRouter.popToRootWithResult<string>('哈哈')
          ZRouter.getInstance().popToRootWithResult<string>('哈哈')
        })

      }

    }
    .title('harAPage3')
    .width('100%')
    .height('100%')

  }
}
