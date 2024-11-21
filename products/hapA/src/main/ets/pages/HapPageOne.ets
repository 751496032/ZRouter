import { RouterConstants } from "common_library";
import { Route } from "routerapi";

@Route({name: RouterConstants.HAP_A_PAGE_ONE})
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

