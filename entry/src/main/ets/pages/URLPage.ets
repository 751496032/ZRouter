/**
 * @author: HZWei
 * @date: 2024/9/22
 * @desc:
 */
import { Route, ZRouter } from 'routerapi';

@Route({name: 'URLPage'})
@Component
export default struct URLPage {
  build() {
    NavDestination() {
      Column({space:20}) {
        Button('URL1').onClick((event: ClickEvent) => {
           ZRouter.getInstance()
             .navigation("https://www.baidu.com?id=66&name=hspCIndex")
        })

        Button('URL2').onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .navigation("hzw://hello?id=69&name=harAPage3")
        })
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }.width('100%')
    .title('URLPage')
  }
}