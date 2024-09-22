/**
 * @author: HZWei
 * @date: 2024/9/17
 * @desc:
 */
import { router } from '@kit.ArkUI'
import { it } from '@ohos/hypium'
import { IInterceptor, InterceptorInfo, ZRouter } from 'routerapi'
import { GlobalNavigateInterceptor, UrlInterceptor } from '../interceptors/interceptors'

@Entry
@Component
export struct Root{

  aboutToAppear(): void {
    // 第一种方式设置拦截器，字面量对象的形式
    ZRouter.setInterceptor({
      priority: 100,
      process: (info: InterceptorInfo) => {
        console.log("IInterceptor process: ", 100, info.name)
        return info
      }
    } as IInterceptor)
    // 第二种方式设置拦截器，类的实例对象的形式
    ZRouter.setInterceptor(new UrlInterceptor())
  }
  build() {
    Column({space : 15}){
      Button('Navigation').onClick((event: ClickEvent) => {
          router.pushUrl({url:'pages/Index'})
      })

      Button('模拟第三方的Navigation使用ZRouter的API').onClick((event: ClickEvent) => {
        router.pushUrl({url:'pages/Index2'})

      })
    }
    .margin({top: 50})
    .width('100%')
    .height('100%')
  }
}