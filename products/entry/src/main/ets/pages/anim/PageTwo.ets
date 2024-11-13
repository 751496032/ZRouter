/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { Route, ZRouter } from 'routerapi';
import { NavAnimationBuilder as NavAnimationMgr } from 'routerapi/src/main/ets/animation/NavAnimationMgr';

@Builder
export function PageTwoBuilder(name: string, param: Object) {
  PageTwo({ param: param as number })
}

@Route({ name: "PageTwo" })
@Component
export struct PageTwo {
  @State translateOptions: TranslateOptions = {}
  pageId: string = '';
  rectWidth: number = 0;
  param: number = 0;

  registerCallback() {
    ZRouter.getInstance().setAnimationOptions({
      name: this.pageId,
      timeout: 200,
      update: (o: TranslateOptions) => {
        this.translateOptions = o
      },
      startCallback: (mgr: NavAnimationMgr, isPush: boolean, isExit: boolean) => {
        if (isPush) {
          mgr.updateLocation({ x: '100%' })
        } else {
          mgr.updateLocation({ x: '0' })
        }
      },
      endCallback: (mgr: NavAnimationMgr, isPush: boolean, isExit: boolean) => {
        if (isPush) {
          mgr.updateLocation({ x: '0' })
        } else {
          mgr.updateLocation({ x: '100%' })
        }
      },
      onFinish: (mgr: NavAnimationMgr, isPush: boolean, isExit: boolean) => {
        mgr.updateLocation({ x: '0' })
      },
      interactiveCallback: (mgr: NavAnimationMgr, operation: NavigationOperation) => {
        if (operation == NavigationOperation.PUSH) {
          mgr.updateLocation({ x: '100%' })
          animateTo({
            duration: 1000,
            onFinish: () => {
              mgr.updateLocation({ x: '0' })
            }
          }, () => {
            mgr.updateLocation({ x: '0' })
          })
        } else {
          mgr.updateLocation({ x: '0' })
          animateTo({
            duration: 1000,
            onFinish: () => {
              mgr.updateLocation({ x: '0' })
            }
          }, () => {
            mgr.updateLocation({ x: '100%' })
          })
        }
      }
    }
    )
  }

  build() {
    NavDestination() {
      Column() {
        Button('PageOne', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            //将name指定的NavDestination页面信息入栈，传递的数据为param
            ZRouter.getInstance().push('PageOne')
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('pageTwo')
    // .gesture(PanGesture()
    //   .onActionStart((event: GestureEvent) => {
    //     this.rectWidth = event.target.area.width as number;
    //     if (event.offsetX < 0) {
    //       this.pageInfos.pushPath({ name: 'PageOne', param: CustomTransition.getInstance().getAnimationId() });
    //     } else {
    //       this.pageInfos.pop();
    //     }
    //   })
    //   .onActionUpdate((event: GestureEvent) => {
    //     let rate = event.fingerList[0].localX / this.rectWidth;
    //     CustomTransition.getInstance().updateProgress(rate);
    //   })
    //   .onActionEnd((event: GestureEvent) => {
    //     let rate = event.fingerList[0].localX / this.rectWidth;
    //     CustomTransition.getInstance().finishInteractiveAnimation(rate);
    //   }))
    .onAppear(() => {
      this.registerCallback();
    })
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
    .backgroundColor(Color.Yellow)
  }
}