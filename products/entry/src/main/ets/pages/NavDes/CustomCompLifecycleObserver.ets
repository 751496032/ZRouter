import { ZLifecycleObserver, RouterInfo, ZLifecycle } from "routerapi";

/**
 * @author: HZWei
 * @date: 2024/11/19
 * @desc:
 */
@ZLifecycle({name:''})
@Observed
export class CustomCompLifecycleObserver extends ZLifecycleObserver {
  counter = 0
  onReady(context: NavDestinationContext): void {
  }

  onBackPress(): boolean {
    return false
  }


}