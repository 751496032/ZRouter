/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { Route, ZRouter } from 'routerapi';
import { NavAnimationBuilder } from 'routerapi/src/main/ets/animation/NavAnimationMgr';

@Builder
export function PageOneBuilder(name: string, param: Object) {
  PageOne()
}

@Route({ name: "PageOne" })
@Component
export struct PageOne {
  @State translateOptions: TranslateOptions = {}
  pageId: string = '';
  rectWidth: number = 0;
  interactive: boolean = false;

  registerCallback() {
    ZRouter.getInstance().setAnimationOptions({
      name: this.pageId,
      timeout: 200,
      update: (mgr: TranslateOptions) => {
        this.translateOptions = mgr
      },
      startCallback: (mgr: NavAnimationBuilder, isPush: boolean, isExit: boolean,) => {
        if (isPush) {
          mgr.updateLocation({y: '100%'})
        } else {
          mgr.updateLocation({y: '0'})
        }
      },
      endCallback: (mgr: NavAnimationBuilder, isPush: boolean, isExit: boolean) => {
        if (isPush) {
          mgr.updateLocation({y: '0'})
        } else {
          mgr.updateLocation({y: '100%'})
        }
      },
      onFinish: (mgr: NavAnimationBuilder, isPush: boolean, isExit: boolean) => {
        mgr.updateLocation({y: '0'})
      },
      interactiveCallback: (mgr: NavAnimationBuilder, operation: NavigationOperation) => {
        if (operation == NavigationOperation.PUSH) {
          mgr.updateLocation({y: '100%'})
          animateTo({
            duration: 1000,
            onFinish: () => {
              mgr.updateLocation({y: '0'})
            }
          }, () => {
            mgr.updateLocation({y: '0'})
          })
        } else {
          mgr.updateLocation({y: '0'})
          animateTo({
            duration: 1000,
            onFinish: () => {
              mgr.updateLocation({y: '0'})
            }
          }, () => {
            mgr.updateLocation({y: '100%'})
          })
        }
      }
    })
  }

  build() {
    NavDestination() {
      Column() {
        Button(`setInteractive`)
          .onClick(() => {
            NavAnimationBuilder.getInstance().interactive = !NavAnimationBuilder.getInstance().interactive;
            this.interactive = NavAnimationBuilder.getInstance().interactive;
          })

        Button('PageTwo', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            ZRouter.getInstance().push('PageTwo')
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('pageOne')
    .onDisAppear(() => {
      ZRouter.getInstance().deleteAnimationOptions(this.pageId)
    })
    .onReady((context: NavDestinationContext) => {
      if (context.navDestinationId) {
        this.pageId = context.navDestinationId;
        this.registerCallback();
      }
    })
    .translate(this.translateOptions)
    .backgroundColor('#F1F3F5')

    // .gesture(PanGesture()
    //   .onActionStart((event: GestureEvent) => {
    //     this.rectWidth = event.target.area.width as number;
    //     if (event.offsetX < 0) {
    //       this.pageInfos.pushPath({ name: 'pageTwo', param: NavAnimationBuilder.getInstance().getAnimationId() });
    //     } else {
    //       this.pageInfos.pop();
    //     }
    //   })
    //   .onActionUpdate((event: GestureEvent) => {
    //     let rate = event.fingerList[0].localX / this.rectWidth;
    //     NavAnimationBuilder.getInstance().updateProgress(rate);
    //   })
    //   .onActionEnd((event: GestureEvent) => {
    //     let rate: number = event.fingerList[0].localX / this.rectWidth;
    //     NavAnimationBuilder.getInstance().finishInteractiveAnimation(rate);
    //   }))
  }
}