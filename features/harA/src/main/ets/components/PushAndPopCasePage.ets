import { KeyConst, RouterConstants, Student, ToastUtils } from 'common_library';
import { Route, ZRouter } from 'routerapi';


@Route({ name: RouterConstants.PAGE_PUSH_AND_POP_CASE ,needLogin: true})
@Component
export struct PushAndPopCasePage {
  @State message: string = 'Hello World';

  aboutToAppear(): void {
    this.message = ZRouter.getInstance().getParam()?.toString() ?? ""
      ZRouter.getInstance().getParamByKey<string>("key")
  }

  build() {
    NavDestination(){
      Column({space:12}){
        Text(this.message)
        Button('push - 监听上一页返回携带的数据').onClick((event: ClickEvent) => {
          // 上一个页面返回
          ZRouter.getInstance()
            // .setParam('hello')
            .withParam("key1", 55)
            .setPopListener((v)=>{
              ToastUtils.show(JSON.stringify(v.data))
            })
            .push(RouterConstants.HSPC_INDEX_PAGE)

        })

        Button('push - 监听跨多级页面返回携带的数据').onClick((event: ClickEvent) => {
          // 上上个页面返回
          ZRouter.getInstance()
            .setParam('hello')
            // .enableCrossPageParamReturn()
            .setPopListener((r)=>{
                let msg = `from: ${r.from} data: ${r.data}`;
                this.message = msg
            })
            .push(RouterConstants.HARA_PAGE4)
        })


        Button('popToRootWithResult - 返回根视图并携带数据').onClick((event: ClickEvent) => {
          ZRouter.getInstance().popToRootWithResult<string>('哈哈')
        })


        Button("携带参数跳转-withParam").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .withParam(KeyConst.KEY_AGE, 22)
            .withParam(KeyConst.KEY_NAME, "lili")
            .withParam(KeyConst.KEY_SCORE, [80, 90, 100])
            .withParam(KeyConst.KEY_USER_INFO, new Student())
            .navigation(RouterConstants.PAGE_PARAM)

        })

        Button("携带参数跳转-setParam").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam([55, 66, 77])
            .navigation(RouterConstants.PAGE_PARAM)

        })

        Button("携带参数跳转-组件间直接传递参数").onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .setParam(Object({ name: "张三", age: 25, score: [80, 100, 100], userInfo: new Student("李四") }))
            .navigation(RouterConstants.PAGE_PARAM2)

        })


      }

    }
    .title('跳转携带参数与监听pop携带的参数 - PushAndPopCasePage')
    .width('100%')
    .height('100%')

  }
}
