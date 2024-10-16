import { RouterConstants } from '@hzw/common_library';
import { Route, ZRouter } from 'routerapi';

@Route({ name: RouterConstants.HSPC_INDEX_PAGE, needLogin: true, extra: 'hsp' })
@Entry
@Component
struct Index {
  @State message: string =  JSON.stringify(ZRouter.getParam() || '');
  // @State pathStack: NavPathStack = ZRouter.getNavStack()

  aboutToAppear(): void {
    // this.message =  ZRouter.getParamByName('hspCIndex').toString()
    // let param = JSON.stringify(ZRouter.getParam() || '')
    // this.message = param

    // 获取当前页的装饰器上参数
    console.debug('aboutToAppear: ', JSON.stringify(ZRouter.getAnnotationParam()))

  }

  build() {
    NavDestination() {
      Column({space:15}) {
        Text(this.message)
        Button('toHspCPage1').onClick((event: ClickEvent) => {
          ZRouter.push('hspCPage1')
          // this.pathStack.pushPathByName('hspCPage1',null)
        })

        Button('toHspCPage2').onClick((event: ClickEvent) => {
          ZRouter.push('hspCPage2')
        })

        Button('pop(携带参数返回)').onClick((event: ClickEvent) => {
          ZRouter.popWithResult('hspCIndex data')
        })
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
