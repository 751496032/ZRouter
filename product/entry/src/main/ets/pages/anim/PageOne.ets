/**
 * @author: HHBin
 * @date: 2024-11-01
 * @desc:
 */
import { Route, ZRouter } from 'routerapi';
import { NavAnimationBuilder } from 'routerapi/src/main/ets/animation/NavAnimationBuilder';

// import { NAV_STACK_NAME } from './AnimTransitionDemo';

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
      update: (o: TranslateOptions) => {
        this.translateOptions = o
      },
      startCallback: (o: TranslateOptions, isPush: boolean, isExit: boolean,) => {
        if (isPush) {
          o.y = '100%';
        } else {
          o.y = '0';
        }
      },
      endCallback: (o: TranslateOptions, isPush: boolean, isExit: boolean) => {
        if (isPush) {
          o.y = '0';
        } else {
          o.y = '100%';
        }
      },
      onFinish: (o: TranslateOptions, isPush: boolean, isExit: boolean) => {
        o.y = '0';
      },
      interactiveCallback: (o: TranslateOptions, operation: NavigationOperation) => {
        if (operation == NavigationOperation.PUSH) {
          o.y = '100%';
          animateTo({
            duration: 1000,
            onFinish: () => {
              o.y = '0';
            }
          }, () => {
            o.y = '0';
          })
        } else {
          o.y = '0';
          animateTo({
            duration: 1000,
            onFinish: () => {
              o.y = '0';
            }
          }, () => {
            o.y = '100%';
          })
        }
      }
    })
  }

  // pageTransition() {
  //   PageTransitionEnter({ duration: 500, curve: Curve.Linear }).slide(SlideEffect.Bottom)
  //   PageTransitionExit({ duration: 500, curve: Curve.Ease }).slide(SlideEffect.Bottom)
  // }

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