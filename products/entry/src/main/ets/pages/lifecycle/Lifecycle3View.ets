import { RouterConstants } from '@hzw/common_library';
import { ILifecycleObserver, Lifecycle, LifecycleEvent, LifecycleRegistry, Route, ZRouter } from 'routerapi';
import { util } from '@kit.ArkTS';

/**
 * @author: HZWei
 * @date: 2024/11/7
 * @desc:
 */

@Route({ name: RouterConstants.LIFECYCLE3_VIEW })
@Component
export struct Lifecycle3View {
  private hash: number = util.getHash(this)
  private tag: string = `LifecycleMgr ${RouterConstants.LIFECYCLE3_VIEW} ${this.hash}: `
  // 1、初始化生命周期注册对象，用@Lifecycle修饰
  @Lifecycle
  lifecycle: LifecycleRegistry = LifecycleRegistry.create(this);
  @State counter: number = 0

  aboutToAppear(): void {
    // 2、使用addListener设置生命周期函数监听
    this.lifecycle.addListener((e, r) => {
      console.log(this.tag, '--1--',e, r?.name ?? "", r?.navDestinationId ?? "")
      switch (e) {
        case LifecycleEvent.ABOUT_TO_APPEAR:
          break
      }
    })
    this.lifecycle.addListener((e, r) => {
      console.log(this.tag ,'--2--' , e, r?.name ?? "", r?.navDestinationId ?? "")
    })
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text(this.counter.toString())
          .fontColor(Color.Black)
          .fontSize(25)
        Button('Lifecycle3View').onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .navigation(RouterConstants.LIFECYCLE3_VIEW)
        })
        Button("+1")
          .onClick(() => {
            this.counter++;
          })
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }.width('100%')
    .title('Lifecycle3View')
  }
}