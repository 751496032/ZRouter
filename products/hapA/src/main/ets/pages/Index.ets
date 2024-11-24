import { RouterConstants } from 'common_library';
import { ZRouter } from 'routerapi';
import { common } from '@kit.AbilityKit';
import { Logger } from '@hzw/logger';

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
        Button("to hap_page_one").onClick((event: ClickEvent) => {
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
  }
}