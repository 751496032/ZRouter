/**
 * @author: HZWei
 * @date: 2024/11/19
 * @desc: NavDest模版的生命周期观察者
 * 继承该类可以实现NavDestination的生命周期回调
 */
import { RouterInfo } from "../model/RouterInfo";
import { ILifecycleObserver } from "../lifecycle/ILifecycleObserver";

export abstract class ZLifecycleObserver implements ILifecycleObserver {
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

  onAppear(info: RouterInfo): void {
  }

  onDisappear(info: RouterInfo): void {
  }

}