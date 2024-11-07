/**
 * @author: HZWei
 * @date: 2024/9/22
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import { ILifecycleObserver, Lifecycle, LifecycleEvent, LifecycleRegistry, Route, ZRouter } from 'routerapi';




@Route({name: RouterConstants.URL_TEST_PAGE})
@Component
export default struct URLPage {
  @Lifecycle lifecycle: LifecycleRegistry = LifecycleRegistry.create(this);
  @State counter: number = 0

  aboutToAppear(): void {
    console.log('URLPage  getParam: ' + ZRouter.getInstance().getParam())
    this.lifecycle.addListener((e, router) => {
      if (e == LifecycleEvent.ON_APPEAR) {
        this.counter++
      }
    })
    let that = this
    this.lifecycle.addObserver<ILifecycleObserver>({
      aboutToAppear: () => {
        console.log('URLPage lifecycle aboutToAppear')
      },
      onPageShow(){
        console.log('URLPage lifecycle onPageShow')
      },
      onPageHide(){
        console.log('URLPage lifecycle onPageHide')
      },
      aboutToDisappear: () => {
        console.log('URLPage lifecycle aboutToDisappear')
      },
      onWillAppear(r){
        console.log('URLPage lifecycle onWillAppear ',r?.name,r?.navDestinationId)
      },
      onAppear(r){
        console.log('URLPage lifecycle onAppear ',r?.name,r?.navDestinationId)
        that.counter++
      },
      onShown(r){

        console.log('URLPage lifecycle onShown ',r?.name,r?.navDestinationId)
      },
      onHidden(r){
        console.log('URLPage lifecycle  onHidden ',r?.name,r?.navDestinationId)
      },
      onWillDisappear(r){
        console.log('URLPage lifecycle  onWillDisappear ',r?.name,r?.navDestinationId)
      },
      onDisappear(r){
        console.log('URLPage lifecycle onDisappear ',r?.name,r?.navDestinationId)
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
              .setLunchMode(LaunchMode.STANDARD)
              .setParam(999)
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