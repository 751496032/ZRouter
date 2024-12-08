import { RouterConstants } from "@hzw/common_library";
import { ZLifecycleObserver, RouterInfo, ZLifecycle } from "routerapi";

/**
 * @author: HZWei
 * @date: 2024/11/19
 * @desc:
 */
@ZLifecycle({ name: RouterConstants.CUSTOM_COMPONENT_CHILD_VIEW })
@Observed
export class CustomCompLifecycleObserver extends ZLifecycleObserver {
  counter = 0
  onReady(context: NavDestinationContext): void {
  }

  onBackPress(): boolean {
    return false
  }
  onShown(info: RouterInfo): void {
  }

  onHidden(info: RouterInfo): void {
  }
}