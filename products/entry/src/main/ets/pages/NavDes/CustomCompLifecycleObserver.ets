import { AbsLifecycleObserver } from "routerapi";

/**
 * @author: HZWei
 * @date: 2024/11/19
 * @desc:
 */
@Observed
export class CustomCompLifecycleObserver extends AbsLifecycleObserver {
  counter = 0
  onReady(context: NavDestinationContext): void {
  }

  onBackPress(): boolean {
    return false
  }
}