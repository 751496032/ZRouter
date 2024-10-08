import { RouterConstants } from 'common_library';
import { Route, ZRouter } from 'routerapi';


@Route({ name: RouterConstants.HARA_MAIN_PAGE, description: "测试", needLogin: true })
@Component
export struct MainPage {
  @State message: string = 'Hello World';
  @State isNewStack: boolean = ZRouter.getCurrentStackName() == "newNavStack";

  aboutToAppear(): void {

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

        }.visibility(this.isNewStack ? Visibility.Hidden : Visibility.Visible)

        Button('back newNavStack').onClick((event: ClickEvent) => {
          ZRouter.getInstance('newNavStack').popWithResult(Math.random() + 10)
        })
      }

    }
    .title('harAMainPage')
    .width('100%')
    .height('100%')

  }
}
