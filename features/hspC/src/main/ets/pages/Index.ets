import { RouterConstants, ToastUtils } from '@hzw/common_library';
import { Route, ZRouter } from 'routerapi';

@Route({ name: RouterConstants.HSPC_INDEX_PAGE, needLogin: true})
@Entry
@Component
struct Index {
  @State message: string =  JSON.stringify(ZRouter.getInstance().getParam() || '');
  // @State pathStack: NavPathStack = ZRouter.getNavStack()

  aboutToAppear(): void {
    // this.message =  ZRouter.getParamByName('hspCIndex').toString()
    // let param = JSON.stringify(ZRouter.getParam() || '')
    // this.message = param

    // 获取当前页的装饰器上参数
    console.debug('aboutToAppear: ', JSON.stringify(ZRouter.getAnnotationParam()))
    console.debug('aboutToAppear param key: ' + ZRouter.getInstance().getParamByKey<string>('key1'))

  }

  build() {
    NavDestination() {
      Column({space:15}) {
        Text(this.message)
        Button('toHspCPage1').onClick((event: ClickEvent) => {
          // ZRouter.push('hspCPage1')
          ZRouter.getInstance()
            .setPopListener((result) => {
              ToastUtils.show('in HspCPage1 from: ' + result.from + '  data: ' + JSON.stringify(result.data))
            })
            .push("hspCPage1")
        })

        Button('toHspCPage2').onClick((event: ClickEvent) => {
          // ZRouter.push('hspCPage2')
          ZRouter.getInstance()
            .setPopListener((result) => {
              ToastUtils.show('in HspCPage2 from: ' + result.from + '  data: ' + JSON.stringify(result.data))
            })
            .push("hspCPage2")
        })

        Button('popWithResult - 携带参数返回上一页').onClick((event: ClickEvent) => {
          // ZRouter.popWithResult('hspCIndex data')
          // ZRouter.getInstance().popWithResult(undefined)
          ZRouter.getInstance().popWithResult('hspCIndex data')
        })

        Button('popWithResult - 携带参数返回上一页 - false').onClick((event: ClickEvent) => {
          ZRouter.getInstance().popWithResult(false)
        })


        Button('popWithResult - 携带参数返回上一页 - 0').onClick((event: ClickEvent) => {
          ZRouter.getInstance().popWithResult(0)
        })

        if (!ZRouter.getParamByKey<boolean>('isRoot',false)) {
          Button('pop 案例').onClick((event: ClickEvent) => {
            ZRouter.getInstance()
              .setPopListener((result) => {
                ToastUtils.show('from: ' + result.from + '  data: ' + JSON.stringify(result.data))
              })
              .push(RouterConstants.PAGE_POP_CASE)
          })
        }


      }
      .width('100%')
    }
    .title('hspCIndex')
    .height('100%')
    .onReady((data)=>{
      // this.pathStack = data.pathStack
      // console.debug("hsp Index : ",data.getConfigInRouteMap()?.name)
    })
  }
}

export { Index };
