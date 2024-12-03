import {  RouterInfo, ZLifecycleObserver } from "routerapi";

/**
 * @author: HZWei
 * @date: 2024/11/19
 * @desc:
 */
@Observed
export class CustomCompLifecycleObserver extends ZLifecycleObserver {
  counter = 0
  onReady(context: NavDestinationContext): void {
  }

  onBackPress(): boolean {
    return false
  }


}