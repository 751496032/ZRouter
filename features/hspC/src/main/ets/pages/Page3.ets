import { RouterConstants } from '@hzw/common_library';
import { NavAnimationModifier, Route, TranslateAnimationOptions, ZRouter } from 'routerapi';

@Route({ name: RouterConstants.HSPC_PAGE3 })
@Component
export struct Page3 {
  @State message: string = 'Hello World';
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Button('pop').onClick((event: ClickEvent) => {
          ZRouter.pop()
        })
      }
    }
    .title(RouterConstants.HSPC_PAGE3)
    .onReady((context:NavDestinationContext)=>{
      ZRouter.animateMgr().registerAnimParam(this,context)
        .addAnimateOptions(new TranslateAnimationOptions({ y: '100%' }))

    })
    .onDisAppear(() => {
      ZRouter.animateMgr().unregisterAnim(this)
    })
    .attributeModifier( ZRouter.animateMgr().modifier(this))
    .width('100%')
    .height('100%')
  }
}
