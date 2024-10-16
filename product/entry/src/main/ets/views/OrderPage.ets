import { RouterConstants } from "@hzw/common_library";
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