import { RouterConstants } from '@hzw/common_library';
import { ILifecycleObserver, Lifecycle, LifecycleEvent, LifecycleRegistry, Route, ZRouter } from 'routerapi';
import { util } from '@kit.ArkTS';
import { LifecycleModel } from '../../model/LifecycleModel';
import { Lifecycle2Model } from '../../model/Lifecycle2Model';

/**
 * @author: HZWei
 * @date: 2024/11/7
 * @desc:
 */

@Route({ name: RouterConstants.LIFECYCLE4_VIEW })
@Component
export struct Lifecycle4View {
  /**
   * 一个页面只能addObserver注册一次
   */
  @State viewModel : LifecycleModel = new LifecycleModel()
  // @State viewModel2 : Lifecycle2Model = new Lifecycle2Model()
  @Lifecycle lifecycle: LifecycleRegistry = LifecycleRegistry.create(this);

  aboutToAppear(): void {
    this.lifecycle.addObserver(this.viewModel)

    // this.viewModel2.register(this.lifecycle)
  }

  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text(this.viewModel.counter === 0 ? this.viewModel.loadState : this.viewModel.counter.toString())
          .fontColor(Color.Black)
          .fontSize(25)

        Button("+1")
          .onClick(() => {
            this.viewModel.counter++;
          })
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }.width('100%')
    .title('Lifecycle4View')
  }
}