/**
 * @author: HZWei
 * @date: 2024/7/21
 * @desc: 404页面  测试一个ets文件多个子页面
 */
import { Route } from 'routerapi/src/main/ets/annotation/Route'
import { ZRouter } from 'routerapi/src/main/ets/api/Router'
import { HashMap } from '@kit.ArkTS'

@Route({name: 'PageNotFound'})
@Component
export struct EmptyPage {


  aboutToAppear(): void {
    const r: Record<string, string> = {}
    if (r.id) {

    }
    this.test()
  }

  @Builder
  private buildItem(){
    Column(){

    }
  }


  async test(): Promise<HashMap<string, string>> {
    let map = new HashMap<string, string>()
    return Promise.resolve(map)
  }

  build() {
    NavDestination() {
      Column() {
         Text('页面丢失了....')
           .margin(20)

        Button('返回').onClick((event: ClickEvent) => {
          ZRouter.pop()
        })
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }.width('100%')
    .title('PageNotFound')
  }
}

@Route({name: 'PageNotFound2'})
@Component
export struct EmptyPage2 {

  async test(): Promise<string> {
    return await this.test2()
  }

  async test2(): Promise<string> {
    return Promise.resolve('test2')
  }
  build() {
    NavDestination() {
      Column() {
        Text('页面丢失了....')
          .margin(20)

        Button('返回').onClick((event: ClickEvent) => {
          ZRouter.pop()
        })
      }.width('100%')
      .height('100%')
      .alignItems(HorizontalAlign.Center)

    }.width('100%')
    .title('PageNotFound2')
  }
}

@Component
export struct  PageNotFound3{
  build() {
  }
}

@CustomDialog
export struct Dialog {
  private controller: CustomDialogController

  build() {
  }
}