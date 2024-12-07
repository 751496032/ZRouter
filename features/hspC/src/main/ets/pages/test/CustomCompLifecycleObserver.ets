import { RouterConstants } from "@hzw/common_library";
import {  RouterInfo, ZLifecycle, ZLifecycleObserver } from "routerapi";

/**
 * @author: HZWei
 * @date: 2024/11/19
 * @desc:
 */
@ZLifecycle({ name: RouterConstants.CUSTOM_COMPONENT_VIEW_HSP })
@Observed
export class CustomCompLifecycleObserver extends ZLifecycleObserver {
  counter = 0
  onReady(context: NavDestinationContext): void {
  }

  onBackPress(): boolean {
    return false
  }


}