/**
 * @author: HZWei
 * @date: 2024/7/21
 * @desc: 空白页
 */
import { Route } from 'routerapi/src/main/ets/annotation/Route'
import { ZRouter } from 'routerapi/src/main/ets/api/Router'

@Route({name: 'PageNotFound'})
@Component
export struct EmptyPage {
  build() {
    NavDestination() {
      Column() {
         Text('页面丢失了....')
           .margin(20)

        Button('返回').onClick((event: ClickEvent) => {
          ZRouter.pop()
        })
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }.width('100%')
    .title('PageNotFound')
  }
}