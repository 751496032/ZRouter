/**
 * @author: HHBin
 * @date: 2024-11-03
 * @desc:
 */
import { Route } from 'routerapi';
import { CustomTransition } from 'routerapi/src/main/ets/model/AnimationUtils';

@Builder
export function PageThreeBuilder(name: string, param: Object) {
  PageThree({ param: param as number })
}

@Route({ name: "PageThree" })
@Component
export struct PageThree {
  pageInfos: NavPathStack = new NavPathStack();
  @State translateY: string = '0';
  pageId: string = '';
  rectWidth: number = 0;
  param: number = 0;

  registerCallback() {
    CustomTransition.getInstance().registerNavParam(this.pageId, (isPush: boolean, isExit: boolean) => {
      if (isPush) {
        this.translateY = '100%'
      } else {
        this.translateY = '0';
      }
    }, (isPush: boolean, isExit: boolean) => {
      if (isPush) {
        this.translateY = '0';
      } else {
        this.translateY = '100%'
      }
    }, (isPush: boolean, isExit: boolean) => {
      this.translateY = '0';
    }, (operation: NavigationOperation) => {
      if (operation == NavigationOperation.PUSH) {
        this.translateY = '100%';
        animateTo({
          duration: 500, onFinish: () => {
            this.translateY = '0';
          }
        }, () => {
          this.translateY = '0'
        })
      } else {
        this.translateY = '0';
        animateTo({
          duration: 500, onFinish: () => {
            this.translateY = "0"
          }
        }, () => {
          this.translateY = '100%';
        })
      }
    }, 2000)
  }

  build() {
    NavDestination() {
      Column() {
        Button('pushPathByName', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            //将name指定的NavDestination页面信息入栈，传递的数据为param
            this.pageInfos.pushPath({ name: 'PageOne', param: CustomTransition.getInstance().getAnimationId() })
          })
      }
      .size({ width: '100%', height: '100%' })
    }
    .title('pageThree')
    .gesture(PanGesture()
      .onActionStart((event: GestureEvent) => {
        this.rectWidth = event.target.area.width as number;
        if (event.offsetX < 0) {
          this.pageInfos.pushPath({ name: 'PageOne', param: CustomTransition.getInstance().getAnimationId() });
        } else {
          this.pageInfos.pop();
        }
      })
      .onActionUpdate((event: GestureEvent) => {
        let rate = event.fingerList[0].localX / this.rectWidth;
        CustomTransition.getInstance().updateProgress(rate);
      })
      .onActionEnd((event: GestureEvent) => {
        let rate = event.fingerList[0].localX / this.rectWidth;
        CustomTransition.getInstance().finishInteractiveAnimation(rate);
      }))
    .onAppear(() => {
      this.registerCallback();
    })
    .onDisAppear(() => {
      CustomTransition.getInstance().unRegisterNavParam(this.pageId);
    })
    .onReady((context: NavDestinationContext) => {
      this.pageInfos = context.pathStack;
      if (context.navDestinationId) {
        this.pageId = context.navDestinationId;
        this.registerCallback();
      }
    })
    .translate({ y: this.translateY })
    .backgroundColor(Color.Yellow)
  }
}