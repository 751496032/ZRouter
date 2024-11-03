/**
 * @author: HZWei
 * @date: 2024/9/22
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import { ILifecycleObserver, Lifecycle, LifecycleEvent, LifecycleRegistry, Route, ZRouter } from 'routerapi';

import { RouterConst } from '../constants/RouterConst';
import { util } from '@kit.ArkTS';


@Route({name: RouterConstants.URL_TEST_PAGE})
@Component
export default struct URLPage {
  @Lifecycle(RouterConstants.URL_TEST_PAGE)
  lifecycle: LifecycleRegistry = LifecycleRegistry.create();
  @State counter: number = 0

  aboutToAppear(): void {
    this.lifecycle.addListener((e, router) => {
      if (e == LifecycleEvent.ON_SHOWN) {
        this.counter++
      }
    })
    let that = this
    this.lifecycle.addObserver<ILifecycleObserver>({
      aboutToAppear: () => {
        console.log('URLPage aboutToAppear')
      },
      onPageShow(){
        console.log('URLPage onPageShow')
      },
      onPageHide(){
        console.log('URLPage onPageHide')
      },
      aboutToDisappear: () => {
        console.log('URLPage aboutToDisappear')
      },
      onAppear(r){
        console.log('URLPage onAppear ',r?.name)
      },
      onShown(r){
        that.counter++
        console.log('URLPage onShown ',r?.name)
      },
      onHidden(r){
        console.log('URLPage onHidden ',r?.name)
      },
      onDisappear(r){
        console.log('URLPage onDisappear ',r?.name)
      }
    })
  }

  build() {
    NavDestination() {
      Column({space:20}) {

        Text(this.counter.toString())
          .fontColor(Color.Black)
          .fontSize(25)
        Button('https://www.baidu.com?id=66&name=hspCIndex').onClick((event: ClickEvent) => {
           ZRouter.getInstance()
             .navigation("https://www.baidu.com?id=66&name=hspCIndex")
        })

        Button('hzw://hello?id=69&name=harAPage3').onClick((event: ClickEvent) => {
          ZRouter.getInstance()
            .navigation("hzw://hello?id=69&name=harAPage3")
        })

        Button("URLPage")
          .onClick(() => {
            ZRouter.getInstance()
              .setLunchMode(LaunchMode.NEW_INSTANCE)
              .navigation(RouterConstants.URL_TEST_PAGE)
          })

        Button("+1")
          .onClick(() => {
              this.counter++;
          })
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }.width('100%')
    .title('URLPage')
  }
}