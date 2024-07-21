import { Route } from 'routerapi/src/main/ets/annotation/Route';
import { ZRouter } from 'routerapi/src/main/ets/api/Router';

@Route({ name: "hspCIndex", needLogin: true, extra: 'hsp' })
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State pathStack: NavPathStack = ZRouter.getNavStack()

  build() {
    NavDestination() {
      Column({space:15}) {
        Button('toHspCPage1').onClick((event: ClickEvent) => {
          ZRouter.push('hspCPage1')
          // this.pathStack.pushPathByName('hspCPage1',null)
        })

        Button('toHspCPage2').onClick((event: ClickEvent) => {
          ZRouter.push('hspCPage2')
        })
      }
      .width('100%')
    }
    .title('hspCIndex')
    .height('100%')
    .onReady((data)=>{
      this.pathStack = data.pathStack
      console.debug("hsp Index : ",data.getConfigInRouteMap()?.name)
    })
  }
}

export { Index };
