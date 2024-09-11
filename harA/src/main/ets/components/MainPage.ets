import { Route, ZRouter } from 'routerapi';


@Route({ name: "harAMainPage", description: "测试",needLogin: true })
@Component
export struct MainPage {
  @State message: string = 'Hello World';

  aboutToAppear(): void {
    // 添加拦截器
    ZRouter.addInterceptor('key',(info)=>{

    })
  }

  aboutToDisappear(): void {
    // 移除拦截器
    ZRouter.removeInterceptor('key')
    ZRouter.create()
      .setLunchMode(LaunchMode.STANDARD)
      .setAnimation(false)
      .setParam("")
      .setOnPopCallback((data)=>{
      })
      .navigation("555")
  }

  build() {
    NavDestination(){
      Column({space:12}){
        Button('toHarAPage1').onClick((event: ClickEvent) => {
          ZRouter.push("harAPage1")
        })

        Button('toHarAPage2').onClick((event: ClickEvent) => {
          ZRouter.push("harAPage2")
        })

        Button('toHarBPage1').onClick((event: ClickEvent) => {
          ZRouter.push("harBPage1")
        })

        Button('toHarBPage2').onClick((event: ClickEvent) => {
          ZRouter.push("harBPage2")
        })
      }

    }
    .title('harAMainPage')
    .width('100%')
    .height('100%')

  }
}
