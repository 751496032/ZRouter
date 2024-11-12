/**
 * @author: HHBin
 * @date: 2024-11-10
 * @desc:
 */
// CustomNavigationUtils.ets
import { NavAnimationOptions } from "./NavAnimationOptions";

// 自定义接口，用来保存某个页面相关的转场动画回调和参数
export interface AnimateCallback {
  translateOptions: TranslateOptions
  finish: ((options: TranslateOptions, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  start: ((options: TranslateOptions, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  onFinish: ((options: TranslateOptions, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  interactive: ((options: TranslateOptions, operation: NavigationOperation) => void | undefined) | undefined;
  update: ((options: TranslateOptions) => void | undefined) | undefined
  timeout: (number | undefined) | undefined;
}

const customTransitionMap: Map<string, AnimateCallback> = new Map();

export class NavAnimationBuilder {
  static delegate = new NavAnimationBuilder();
  interactive: boolean = false;
  proxy: NavigationTransitionProxy | undefined = undefined;
  private animationId: number = 0;
  operation: NavigationOperation = NavigationOperation.PUSH

  static getInstance() {
    return NavAnimationBuilder.delegate;
  }

  /* 注册某个页面的动画回调
   * name: 注册页面的唯一id
   * startCallback：用来设置动画开始时页面的状态
   * endCallback：用来设置动画结束时页面的状态
   * onFinish：用来执行动画结束后页面的其他操作
   * interactiveCallback: 注册的可交互转场的动效
   * timeout：转场结束的超时时间
   */
  public setAnimationOptions(options: NavAnimationOptions): void {
    if (options.name) {
      if (customTransitionMap.has(options.name)) {
        let param = customTransitionMap.get(options.name);
        if (param != undefined) {
          param.start = options.startCallback;
          param.finish = options.endCallback;
          param.timeout = options.timeout;
          param.onFinish = options.onFinish;
          param.interactive = options.interactiveCallback;
          return;
        }
      }
      let params: AnimateCallback = {
        translateOptions: {},
        timeout: options.timeout,
        start: options.startCallback,
        finish: options.endCallback,
        update: options.update,
        onFinish: options.onFinish,
        interactive: options.interactiveCallback
      };
      customTransitionMap.set(options.name, params);
    }
  }

  unRegisterNavParam(name: string): void {
    customTransitionMap.delete(name);
  }

  fireInteractiveAnimation(id: string, callback: AnimateCallback, operation: NavigationOperation) {
    let animation = customTransitionMap.get(id)?.interactive;
    if (!animation) {
      return;
    }
    animation(callback.translateOptions, operation);
    if (callback.update) {
      callback.update(callback.translateOptions)
    }
  }

  updateProgress(progress: number) {
    if (!this.proxy?.updateTransition) {
      return;
    }
    progress = this.operation == NavigationOperation.PUSH ? 1 - progress : progress;
    this.proxy?.updateTransition(progress);
  }

  cancelTransition() {
    if (this.proxy?.cancelTransition) {
      this.proxy.cancelTransition();
    }
  }

  recoverState() {
    if (!this.proxy?.from.navDestinationId || !this.proxy?.to.navDestinationId) {
      return;
    }
    let fromParam = customTransitionMap.get(this.proxy.from.navDestinationId);
    if (fromParam?.onFinish) {
      fromParam.onFinish(fromParam.translateOptions, false, false);
    }
    let toParam = customTransitionMap.get(this.proxy?.to.navDestinationId);
    if (toParam?.onFinish) {
      toParam.onFinish(toParam.translateOptions, true, true,);
    }
  }

  finishTransition() {
    this.proxy?.finishTransition();
  }

  finishInteractiveAnimation(rate: number) {
    if (this.operation == NavigationOperation.PUSH) {
      if (rate > 0.5) {
        if (this.proxy?.cancelTransition) {
          this.proxy.cancelTransition();
        }
      } else {
        this.proxy?.finishTransition();
      }
    } else {
      if (rate > 0.5) {
        this.proxy?.finishTransition();
      } else {
        if (this.proxy?.cancelTransition) {
          this.proxy.cancelTransition();
        }
      }
    }
  }

  getAnimateParam(name: string): AnimateCallback {
    let result: AnimateCallback = {
      translateOptions: customTransitionMap.get(name)?.translateOptions ?? {},
      start: customTransitionMap.get(name)?.start,
      finish: customTransitionMap.get(name)?.finish,
      update: customTransitionMap.get(name)?.update,
      timeout: customTransitionMap.get(name)?.timeout,
      onFinish: customTransitionMap.get(name)?.onFinish,
      interactive: customTransitionMap.get(name)?.interactive,
    };
    return result;
  }

  static customNavContentTransition = (from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation) => {
    if (from.mode == NavDestinationMode.DIALOG || to.mode == NavDestinationMode.DIALOG) {
      return undefined;
    }

    NavAnimationBuilder.getInstance().operation = operation;
    if (NavAnimationBuilder.getInstance().interactive) {
      let customAnimation: NavigationAnimatedTransition = {
        onTransitionEnd: (isSuccess: boolean) => {
          console.log("===== current transition is " + isSuccess);
          NavAnimationBuilder.getInstance().recoverState();
          NavAnimationBuilder.getInstance().proxy = undefined;
        },
        transition: (transitionProxy: NavigationTransitionProxy) => {
          NavAnimationBuilder.getInstance().proxy = transitionProxy;
          let targetIndex: string | undefined = operation == NavigationOperation.PUSH ?
            (to.navDestinationId) : (from.navDestinationId);

          if (targetIndex) {
            let fromParam: AnimateCallback | undefined =
              from.navDestinationId ? NavAnimationBuilder.getInstance().getAnimateParam(targetIndex) : undefined;
            if (fromParam) {
              NavAnimationBuilder.getInstance()
                .fireInteractiveAnimation(targetIndex, fromParam, operation);
            }
          }
        },
        isInteractive: NavAnimationBuilder.getInstance().interactive
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
          from.navDestinationId ? NavAnimationBuilder.getInstance().getAnimateParam(from.navDestinationId) : undefined;
        let toParam: AnimateCallback | undefined =
          to.navDestinationId ? NavAnimationBuilder.getInstance().getAnimateParam(to.navDestinationId) : undefined;
        if (operation == NavigationOperation.PUSH) {
          if (toParam?.start) {
            toParam.start(toParam.translateOptions, true, false);
          }
          if (toParam?.update) {
            toParam.update(toParam.translateOptions);
          }
          animateTo({
            duration: 500, onFinish: () => {
              transitionProxy.finishTransition();
            }
          }, () => {
            if (toParam?.finish) {
              toParam.finish(toParam.translateOptions, true, false);
            }
            if (toParam?.update) {
              toParam.update(toParam.translateOptions);
            }
          })
        } else {
          if (fromParam?.start) {
            fromParam.start(fromParam.translateOptions, false, true);
          }
          if (fromParam?.update) {
            fromParam.update(fromParam.translateOptions);
          }
          animateTo({
            duration: 500, onFinish: () => {
              transitionProxy.finishTransition();
            }
          }, () => {
            if (fromParam?.finish) {
              fromParam.finish(fromParam.translateOptions, false, true);
            }
            if (fromParam?.update) {
              fromParam.update(fromParam.translateOptions);
            }
          })
        }
      }
    };
    return customAnimation;
  }
}