import { Route } from "@hzw/zrouter";
import { RouterConstants, RouterMap } from "common_library";

// @Route({name: RouterConstants.HAP_A_PAGE_ONE})
@Route({name: RouterMap.HapA.HAP_A_PAGE_ONE})
@Component
export struct HapPageOne {
  build() {
    NavDestination(){
      Column({ space: 15 }) {
        Text("hello, world!")
      }
    }
  }
}

