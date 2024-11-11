import { AnimateCallback, CustomTransition } from "./AnimationUtils";

/**
 * @author: HHBin
 * @date: 2024-11-10
 * @desc: 路由动画转场配置
 */
export class AnimationOptionsBuilder {
  static customNavContentTransition = (from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation) => {
    if (from.mode == NavDestinationMode.DIALOG || to.mode == NavDestinationMode.DIALOG) {
      return undefined;
    }

    CustomTransition.getInstance().operation = operation;
    if (CustomTransition.getInstance().interactive) {
      let customAnimation: NavigationAnimatedTransition = {
        onTransitionEnd: (isSuccess: boolean) => {
          console.log("===== current transition is " + isSuccess);
          CustomTransition.getInstance().recoverState();
          CustomTransition.getInstance().proxy = undefined;
        },
        transition: (transitionProxy: NavigationTransitionProxy) => {
          CustomTransition.getInstance().proxy = transitionProxy;
          let targetIndex: string | undefined = operation == NavigationOperation.PUSH ?
            (to.navDestinationId) : (from.navDestinationId);
          if (targetIndex) {
            CustomTransition.getInstance().fireInteractiveAnimation(targetIndex, operation);
          }
        },
        isInteractive: CustomTransition.getInstance().interactive
      }
      return customAnimation;
    }
    let customAnimation: NavigationAnimatedTransition = {
      onTransitionEnd: (isSuccess: boolean) => {
        console.log(`current transition result is ${isSuccess}`)
      },
      timeout: 7000,
      // 转场开始时系统调用该方法，并传入转场上下文代理对象
      transition: (transitionProxy: NavigationTransitionProxy) => {
        // 从封装类CustomTransition中根据子页面的序列获取对应的转场动画回调
        let fromParam: AnimateCallback | undefined =
          from.navDestinationId ? CustomTransition.getInstance().getAnimateParam(from.navDestinationId) : undefined;
        let toParam: AnimateCallback | undefined =
          to.navDestinationId ? CustomTransition.getInstance().getAnimateParam(to.navDestinationId) : undefined;
        if (operation == NavigationOperation.PUSH) {
          if (toParam?.start) {
            toParam.start(true, false);
          }
          animateTo({
            duration: 500, onFinish: () => {
              transitionProxy.finishTransition();
            }
          }, () => {
            if (toParam?.finish) {
              toParam.finish(true, false);
            }
          })
        } else {
          if (fromParam?.start) {
            fromParam.start(false, true);
          }
          animateTo({
            duration: 500, onFinish: () => {
              transitionProxy.finishTransition();
            }
          }, () => {
            if (fromParam?.finish) {
              fromParam.finish(false, true);
            }
          })
        }
      }
    };
    return customAnimation;
  }
}

