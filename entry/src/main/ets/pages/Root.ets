/**
 * @author: HZWei
 * @date: 2024/9/17
 * @desc:
 */
import { router } from '@kit.ArkUI'
import { ShowInterceptor, ZRouter } from 'routerapi'

@Entry
@Component
export struct Root{

  aboutToAppear(): void {
    ZRouter.setInterceptor<ShowInterceptor>("11", {
      onRootWillShow: (r) => {

      },
      onPageWillShow: (from, to) => {
      }
    })
  }
  build() {
    Column({space : 15}){
      Button('Navigation1').onClick((event: ClickEvent) => {
          router.pushUrl({url:'pages/Index'})
      })

      Button('Navigation2').onClick((event: ClickEvent) => {
        router.pushUrl({url:'pages/NavIndex'})

      })
    }
    .width('100%')
    .height('100%')
  }
}