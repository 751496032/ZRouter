// import { RouterConstants } from "@hzw/common_library/src/main/ets/constants/RouterConstants"; // 不建议这样导入
import { RouterConstants } from "@hzw/common_library" // 建议
import { Route } from "routerapi";

@Route({ name: RouterConstants.ORDER_PAGE })
@Component
export struct OrderPage {

  build() {
    NavDestination() {
      Column({space:20}) {
        Text('order page')
      }
      .width('100%')
      .height('100%')
    }
    .width("100%")
    .height("100%")

  }
}