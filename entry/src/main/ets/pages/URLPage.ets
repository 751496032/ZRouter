/**
 * @author: HZWei
 * @date: 2024/9/22
 * @desc:
 */
import { Route, ZRouter,Const } from 'routerapi';

// export class Const {
//   public static readonly URL_PAGE = "URL_PAGE"
// }

@Route({name: Const.TEST})
@Component
export default struct URLPage {
  build() {
    NavDestination() {
      Column({space:20}) {
        Button('https://www.baidu.com?id=66&name=hspCIndex').onClick((event: ClickEvent) => {
           ZRouter.getInstance()
             .navigation("https://www.baidu.com?id=66&name=hspCIndex")
        })

        Button('hzw://hello?id=69&name=harAPage3').onClick((event: ClickEvent) => {
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