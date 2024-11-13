/**
 * @author: HZWei
 * @date: 2024/9/22
 * @desc:
 * 模拟配置URL路径跳转
 * 拦截器案例参考UrlInterceptor
 */
import { RouterConstants } from '@hzw/common_library';
import {  Route, ZRouter } from 'routerapi';

@Route({name: RouterConstants.CUSTOM_URL_PAGE})
@Component
export default struct URLPage {
  @State counter: number = 0

  build() {
    NavDestination() {
      Column({space:20}) {
        Text(this.counter.toString())
          .fontColor(Color.Black)
          .fontSize(25)
        Button('https://www.baidu.com?id=66&name=hspCIndex').onClick((event: ClickEvent) => {
           ZRouter.getInstance()
             .navigation("https://www.baidu.com?id=66&name=hspCIndex")
        })

        Button('hzw://hello?id=69&name=harAPage3').onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .navigation("hzw://hello?id=69&name=harAPage3")
        })

        Button("URLPage")
          .onClick(() => {
            ZRouter.getInstance()
              .setLunchMode(LaunchMode.STANDARD)
              .setParam(999)
              .navigation(RouterConstants.CUSTOM_URL_PAGE)
          })

        Button("+1")
          .onClick(() => {
              this.counter++;
          })
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }.width('100%')
    .title('自定义URL跳转')
  }
}