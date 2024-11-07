import { RouterConstants } from '@hzw/common_library';
import { ILifecycleObserver, Lifecycle, LifecycleEvent, LifecycleRegistry, Route, ZRouter } from 'routerapi';
import { util } from '@kit.ArkTS';

/**
 * @author: HZWei
 * @date: 2024/11/7
 * @desc:
 */

@Route({ name: RouterConstants.LIFECYCLE1_VIEW })
@Component
export struct Lifecycle1View {
  private hash: number = util.getHash(this)
  private tag: string = `LifecycleMgr ${RouterConstants.LIFECYCLE1_VIEW} ${this.hash}: `
  // 1、初始化生命周期注册对象，并使用@Lifecycle注解LifecycleRegistry实例
  @Lifecycle lifecycle: LifecycleRegistry = LifecycleRegistry.create(this);
  @State counter: number = 0


  aboutToAppear(): void {
    // 2、使用addObserver设置生命周期函数监听
    // 注意：如果addObserver是字面量对象注册的情况，将this设置局部变量，不然在对象内的this指向会不对
    let that = this
    this.lifecycle.addObserver<ILifecycleObserver>({
      aboutToAppear: () => {
        console.log(`${that.tag}aboutToAppear`)
      },
      onPageShow() {
        console.log(`${that.tag}onPageShow`)
      },
      onPageHide() {
        console.log(`${that.tag}onPageHide`)
      },
      aboutToDisappear: () => {
        console.log(`${that.tag}aboutToDisappear`)
      },
      onWillAppear(r) {
        console.log(`${that.tag}onWillAppear`,r?.name, r?.navDestinationId)
      },
      onAppear(r) {
        console.log(`${that.tag}onAppear`, r?.name, r?.navDestinationId)
        that.counter++
      },
      onShown(r) {
        console.log(`${that.tag}onShown `,r?.name, r?.navDestinationId)
      },
      onHidden(r) {
        console.log(`${that.tag}onHidden `, r?.name, r?.navDestinationId)
      },
      onWillDisappear(r) {
        console.log(`${that.tag}onWillDisappear `,r?.name, r?.navDestinationId)
      },
      onDisappear(r) {
        console.log(`${that.tag}onDisappear `, r?.name, r?.navDestinationId)
      }
    })
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text(this.counter.toString())
          .fontColor(Color.Black)
          .fontSize(25)

        Button('Lifecycle1View').onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .navigation(RouterConstants.LIFECYCLE1_VIEW)
        })

        Button('Lifecycle2View').onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .navigation(RouterConstants.LIFECYCLE2_VIEW)
        })



        Button("+1")
          .onClick(() => {
            this.counter++;
          })
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }.width('100%')
    .title('Lifecycle1View')
  }
}