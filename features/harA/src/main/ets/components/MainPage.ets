import { RouterConstants, commonTest } from 'common_library';
import { ILifecycleObserver, Lifecycle, LifecycleRegistry, Route, ZRouter } from 'routerapi';


@Route({ name: RouterConstants.HARA_MAIN_PAGE, description: "测试", needLogin: true })
@Component
export struct MainPage {
  @State message: string = 'Hello World';
  @State isNewStack: boolean = ZRouter.getCurrentStackName() == "newNavStack";
  @Lifecycle
  lifecycle: LifecycleRegistry = LifecycleRegistry.create(this)

  aboutToAppear(): void {
    console.log("harA MainPage aboutToAppear")

    // 生命周期监听
    const that = this
    this.lifecycle.addObserver({
      aboutToAppear(): void {
        console.log('MainPage  aboutToAppear ' + that.lifecycle)
      },
      onPageShow(): void {
        console.log('MainPage  onPageShow')
      },

      onPageHide(): void {
        console.log('MainPage  onPageHide')
      },
      aboutToDisappear(): void {
        console.log('MainPage  aboutToDisappear')
      },
      onShown(r): void {
        console.log('MainPage  onShown', r?.name)
      },

      onHidden(r): void {
        console.log('MainPage  onHidden', r?.name)
      },
      onDisappear(r): void {
        console.log('MainPage  onDisappear', r?.name)
      }


    } as ILifecycleObserver)
  }

  aboutToDisappear(): void {
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column({ space: 12 }) {
          Button('toHarAPage1').onClick((event: ClickEvent) => {
            // ZRouter.push("harAPage1")
            ZRouter.getInstance().push("harAPage1")
          })

          Button('toHarAPage2').onClick((event: ClickEvent) => {
            // ZRouter.push("harAPage2")
            ZRouter.getInstance().push("harAPage2")
          })

          Button('toHarBPage1').onClick((event: ClickEvent) => {
            // ZRouter.push("harBPage1")
            ZRouter.getInstance().push("harBPage1")
          })

          Button('toHarBPage2').onClick((event: ClickEvent) => {
            // ZRouter.push("harBPage2")
            ZRouter.getInstance().push("harBPage2")
          })

          Button('replace').onClick((event: ClickEvent) => {
            // ZRouter.push("harBPage2")
            ZRouter.getInstance().replace(RouterConstants.ORDER_PAGE)
          })

        }.visibility(this.isNewStack ? Visibility.Hidden : Visibility.Visible)

        Button('back newNavStack').onClick((event: ClickEvent) => {
          ZRouter.getInstance('newNavStack').popWithResult(Math.random() + 10)
        }).visibility(this.isNewStack ? Visibility.Visible : Visibility.Hidden)
      }

    }
    .title('harAMainPage')
    .width('100%')
    .height('100%')

  }
}
