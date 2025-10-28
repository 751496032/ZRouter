/**
 * @author: HZWei
 * @date: 2024/12/23
 * @desc:
 */
import { RouterConstants } from "@hzw/common_library";
import { RouterInfo, ZLifecycle, ZLifecycleObserver } from "routerapi";

const TAG = "NavDestV2ViewModel"

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

  onReady(context: NavDestinationContext): void {
    console.log(TAG, "onReady")
  }

  onWillAppear(info: RouterInfo): void {
    console.log(TAG, "onWillAppear")
  }

  onWillDisappear(info: RouterInfo): void {
    console.log(TAG, "onWillDisappear")
  }

  onWillShow(info: RouterInfo): void {
    console.log(TAG, "onWillShow")
  }

  onWillHide(info: RouterInfo): void {
    console.log(TAG, "onWillHide")
  }
  onShown(info: RouterInfo): void {
    console.log(TAG, "onShown")
  }

  onHidden(info: RouterInfo): void {
    console.log(TAG, "onHidden")
  }

  onDisappear(info: RouterInfo): void {
    console.log(TAG, "onDisappear")
  }

  onAppear(info: RouterInfo): void {
    console.log(TAG, "onAppear")
  }

}


