import { Route, ZRouter } from 'routerapi';


@Route({ name: "harAPage3" })
@Component
export struct Page3 {
  @State message: string = 'Hello World';

  build() {
    NavDestination(){
      Column({space:12}){
        Button('pushForResult').onClick((event: ClickEvent) => {
          // 上一个页面返回
          ZRouter.pushForResult("hspCIndex", 'hello', (data) => {
            AlertDialog.show({ message: JSON.stringify(data.result) })
          })
        })

        Button('pushNavForResult').onClick((event: ClickEvent) => {
          // 上上个页面返回
          ZRouter.pushNavForResult<string>("harAPage4", 'hello', (r) => {
             console.log("result: ", r.data)
          })
        })

      }

    }
    .title('harAPage3')
    .width('100%')
    .height('100%')

  }
}
