/**
 * @author: HZWei
 * @date: 2024/12/23
 * @desc:
 */
import { RouterConstants } from "@hzw/common_library";
import { ZLifecycle, ZLifecycleObserver } from "routerapi";


export class  BaseViewModel  extends  ZLifecycleObserver{
  onBackPress(): boolean {
    return false;
  }

  onReady(context: NavDestinationContext): void {

  }

}

@ZLifecycle({ name: RouterConstants.PAGE_NAVDEST_TEMPLATE_V2 })
@ObservedV2
export class NavDestV2ViewModel extends BaseViewModel {
  @Trace counter = 0;

}


