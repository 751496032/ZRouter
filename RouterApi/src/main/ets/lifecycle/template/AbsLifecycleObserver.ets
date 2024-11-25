/**
 * @author: HZWei
 * @date: 2024/11/19
 * @desc:
 */
import { RouterInfo } from "../../model/RouterInfo";
import { ILifecycleObserver } from "../ILifecycleObserver";

export abstract class AbsLifecycleObserver implements ILifecycleObserver {
  abstract onBackPress(): boolean
  abstract onReady(context: NavDestinationContext): void

  onShown(info: RouterInfo): void {
  }

  onHidden(info: RouterInfo): void {
  }

}