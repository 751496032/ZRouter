import { RouterConstants } from 'common_library';
import { common } from '@kit.AbilityKit';
import { Logger } from '@hzw/logger';
import { ZRouter } from '@hzw/zrouter';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear(): void {

  }

  build() {
    Navigation(ZRouter.getNavStackByName(RouterConstants.HAP)) {
      Column({ space: 20 }) {
        Button("toHapPageOne").onClick((event: ClickEvent) => {
          ZRouter.getInstance(RouterConstants.HAP).navigation(RouterConstants.HAP_A_PAGE_ONE)
        })
      }
    }.onAppear(() => {
      let route = AppStorage.get(RouterConstants.EVENT_HAP_LAUNCH_ROUTER) ?? ""
      Logger.d("route: ", route)
      ZRouter.getInstance(RouterConstants.HAP)
        .setAnimate(false)
        .push(route.toString())
    })
    .title("hapA Index")
  }
}