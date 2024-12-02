/**
 * @author: HZWei
 * @date: 2024/11/19
 * @desc:
 */
import { RouterInfo } from "../../model/RouterInfo";
import { ILifecycleObserver } from "../ILifecycleObserver";

export abstract class ComponentLifecycleObserver implements ILifecycleObserver {
  abstract onBackPress(): boolean
  abstract onReady(context: NavDestinationContext): void

  aboutToAppear(): void {
  }

  aboutToDisappear(): void {
  }

  /**
   * @Entry页面的生命周期函数
   */
  onPageShow(): void {
  }
  /**
   * @Entry页面的生命周期函数
   */
  onPageHide(): void {
  }

  onWillAppear(info: RouterInfo): void {
  }

  onWillDisappear(info: RouterInfo): void {
  }


  onWillShow(info: RouterInfo): void {
  }

  onWillHide(info: RouterInfo): void {
  }

  onShown(info: RouterInfo): void {
  }

  onHidden(info: RouterInfo): void {
  }

}