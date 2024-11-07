
import { ILifecycleObserver, RouterInfo } from "routerapi";

/**
 * @author: HZWei
 * @date: 2024/11/8
 * @desc:  让一个类具有生命周期能力
 */

@Observed
export class LifecycleModel implements ILifecycleObserver {
  private tag = 'LifecycleMgr: '
  loadState: string = "请求数据中..."
  counter: number = 0

  aboutToAppear(): void {
    console.log(this.tag + 'aboutToAppear')
  }

  onPageShow(): void {
    console.log(this.tag + 'onPageShow')
  }

  onPageHide(): void {
    console.log(this.tag + 'onPageHide')
  }

  aboutToDisappear(): void {
    console.log(this.tag + 'aboutToDisappear')
  }

  onWillAppear(info: RouterInfo): void {
    console.log(this.tag + 'onWillAppear')

  }

  onAppear(info: RouterInfo): void {
    console.log(this.tag + 'onAppear')
    // 模拟请求数据
    setTimeout(() => {
      this.counter = 100
    }, 3000)
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
