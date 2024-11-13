/**
 * @author: HZWei
 * @date: 2024/11/10
 * @desc:
 */
import { ILifecycleObserver, RouterInfo } from "routerapi";

/**
 * 全局生命周期观察者 注意：
 * 其中组件的通用生命周期函数（aboutToAppear、aboutToDisAppear）未必一定会被调用，前提取决于NavDestination页面是否了初始化了LifecycleRegistry对象
 * 这个问题会在后续版本中优化。
 */
export class GlobalLifecycleObserverImpl implements ILifecycleObserver {
  private tag = 'LifecycleMgr GlobalLifecycle: '

  aboutToAppear(): void {
    console.log(this.tag + 'aboutToAppear')
  }


  aboutToDisappear(): void {
    console.log(this.tag + 'aboutToDisappear')
  }

  onWillAppear(info: RouterInfo): void {
    console.log(this.tag + 'onWillAppear')

  }

  onAppear(info: RouterInfo): void {
    console.log(this.tag + 'onAppear')

  }

  onWillShow(info: RouterInfo): void {
    console.log(this.tag + 'onWillShow')
  }

  onShown(info: RouterInfo): void {
    console.log(this.tag + 'onShown')
  }

  onWillHide(info: RouterInfo): void {
    console.log(this.tag + 'onWillHide')
  }

  onHidden(info: RouterInfo): void {
    console.log(this.tag + 'onHidden')
  }

  onWillDisappear(info: RouterInfo): void {
    console.log(this.tag + 'onWillDisappear')
  }

  onDisappear(info: RouterInfo): void {
    console.log(this.tag + 'onDisappear')
  }
}