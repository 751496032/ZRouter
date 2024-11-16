/**
 * @author: HHBin
 * @date: 2024-11-10
 * @desc:
 */
// CustomNavigationUtils.ets
import { INavAnimationCallback } from './callback/INavAnimationCallback';
import { NavAnimationCallback } from './callback/NavAnimationCallback';
import { NavAnimationModifier } from './modifier/NavAnimationModifier';
import { INavAnimationParam } from './param/INavAnimationParam';

// 自定义接口，用来保存某个页面相关的转场动画回调和参数
export interface AnimateCallback {
  modifier: NavAnimationModifier
  param: INavAnimationParam
  finish: ((options: AnimateCallback, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  start: ((options: AnimateCallback, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  onFinish: ((options: AnimateCallback, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  interactive: ((options: AnimateCallback, operation: NavigationOperation) => void | undefined) | undefined;
}

/**
 * 路由转场动画管理
 */
export class NavAnimationMgr {
  private static delegate = new NavAnimationMgr();
  private interactive: boolean = false;
  private proxy: NavigationTransitionProxy | undefined = undefined;
  private operation: NavigationOperation = NavigationOperation.PUSH
  private navContextMap: Map<object, NavDestinationContext> = new Map();
  private customTransitionMap: Map<string, AnimateCallback> = new Map();

  static getInstance() {
    return NavAnimationMgr.delegate;
  }

  /**
   * 注册路由转场动画，设置相关参数（推荐）
   * @param modifier
   * @param ctx
   * @param param
   */
  public registerAnimParam(modifier: NavAnimationModifier, ctx: NavDestinationContext,
    param: INavAnimationParam): void {
    const options = new NavAnimationCallback()
    options.param = param
    this.registerAnimCallback(modifier, ctx, options);
  }

  /**
   * 注册路由转场动画，设置相关回调，如果要实现复杂的动画效果可以通过自定义INavAnimationCallback来实现
   * @param modifier
   * @param ctx
   * @param options
   */
  public registerAnimCallback(modifier: NavAnimationModifier, ctx: NavDestinationContext,
    options: INavAnimationCallback): void {
    if (ctx.navDestinationId && !this.navContextMap.has(modifier)) {
      this.navContextMap.set(modifier, ctx)
      const name = ctx.navDestinationId;
      if (this.customTransitionMap.has(name)) {
        let param = this.customTransitionMap.get(name);
        if (param !== undefined) {
          param.modifier = modifier
          param.param = options.param ?? {}
          param.start = options.startCallback;
          param.finish = options.endCallback;
          param.onFinish = options.onFinish;
          param.interactive = options.interactiveCallback;

          param.modifier.callback = param
        }
      }
      let params: AnimateCallback = {
        modifier: modifier,
        param: options.param ?? {},
        start: options.startCallback,
        finish: options.endCallback,
        onFinish: options.onFinish,
        interactive: options.interactiveCallback
      };

      params.modifier.callback = params
      this.customTransitionMap.set(name, params);
    }
  }

  unregisterAnim(component: object) {
    if (this.navContextMap.has(component)) {
      const navId = this.navContextMap.get(component)?.navDestinationId
      if (navId) {
        this.customTransitionMap.delete(navId);
      }
      this.navContextMap.delete(component)
    }
  }

  fireInteractiveAnimation(id: string, callback: AnimateCallback, operation: NavigationOperation) {
    let animation = this.customTransitionMap.get(id)?.interactive;
    if (!animation) {
      return;
    }
    animation(callback, operation);
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
    let fromParam = this.customTransitionMap.get(this.proxy.from.navDestinationId);
    if (fromParam?.onFinish) {
      fromParam.onFinish(fromParam, false, false);
    }
    let toParam = this.customTransitionMap.get(this.proxy?.to.navDestinationId);
    if (toParam?.onFinish) {
      toParam.onFinish(toParam, true, true,);
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
      modifier: this.customTransitionMap.get(name)?.modifier ?? new NavAnimationModifier(),
      param: this.customTransitionMap.get(name)?.param ?? {},
      start: this.customTransitionMap.get(name)?.start,
      finish: this.customTransitionMap.get(name)?.finish,
      onFinish: this.customTransitionMap.get(name)?.onFinish,
      interactive: this.customTransitionMap.get(name)?.interactive,
    };
    return result;
  }

  // 自定义导航内容过渡动画默认实现，在Navigation().customNavContentTransition()设置
  static customNavContentTransition = (from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation) => {
    if (from.mode == NavDestinationMode.DIALOG || to.mode == NavDestinationMode.DIALOG) {
      return undefined;
    }

    const builder = NavAnimationMgr.getInstance()

    builder.operation = operation;
    if (builder.interactive) {
      let customAnimation: NavigationAnimatedTransition = {
        timeout: 7000,
        onTransitionEnd: (isSuccess: boolean) => {
          console.log("===== current transition is " + isSuccess);
          builder.recoverState();
          builder.proxy = undefined;
        },
        transition: (transitionProxy: NavigationTransitionProxy) => {
          builder.proxy = transitionProxy;
          let targetIndex: string | undefined = operation == NavigationOperation.PUSH ?
            (to.navDestinationId) : (from.navDestinationId);

          if (targetIndex) {
            builder.proxy = transitionProxy;
            let targetIndex: string | undefined = operation == NavigationOperation.PUSH ?
              (to.navDestinationId) : (from.navDestinationId);
            if (targetIndex) {
              const callback = builder.getAnimateParam(targetIndex)
              if (callback) {
                builder.fireInteractiveAnimation(targetIndex, callback, operation);
              }
            }
          }
        },
        isInteractive: builder.interactive
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
          from.navDestinationId ? builder.getAnimateParam(from.navDestinationId) : undefined;
        let toParam: AnimateCallback | undefined =
          to.navDestinationId ? builder.getAnimateParam(to.navDestinationId) : undefined;
        if (operation == NavigationOperation.PUSH) {
          if (toParam?.start) {
            toParam.start(toParam, true, false);
          }
          animateTo({
            duration: toParam?.param?.animateParam?.duration,
            tempo: toParam?.param?.animateParam?.tempo,
            curve: toParam?.param?.animateParam?.curve,
            delay: toParam?.param?.animateParam?.delay,
            iterations: toParam?.param?.animateParam?.iterations,
            playMode: toParam?.param?.animateParam?.playMode,
            finishCallbackType: toParam?.param?.animateParam?.finishCallbackType,
            expectedFrameRateRange: toParam?.param?.animateParam?.expectedFrameRateRange,
            onFinish: () => {
              transitionProxy.finishTransition();
              if (toParam?.param?.animateParam?.onFinish) {
                toParam?.param?.animateParam?.onFinish()
              }
            }
          }, () => {
            if (toParam?.finish) {
              toParam.finish(toParam, true, false);
            }
          })
        } else {
          if (fromParam?.start) {
            fromParam.start(fromParam, false, true);
          }
          animateTo({
            duration: fromParam?.param?.animateParam?.duration,
            tempo: fromParam?.param?.animateParam?.tempo,
            curve: fromParam?.param?.animateParam?.curve,
            delay: fromParam?.param?.animateParam?.delay,
            iterations: fromParam?.param?.animateParam?.iterations,
            playMode: fromParam?.param?.animateParam?.playMode,
            finishCallbackType: fromParam?.param?.animateParam?.finishCallbackType,
            expectedFrameRateRange: fromParam?.param?.animateParam?.expectedFrameRateRange,
            onFinish: () => {
              transitionProxy.finishTransition();
              if (fromParam?.param?.animateParam?.onFinish) {
                fromParam?.param?.animateParam?.onFinish()
              }
            }
          }, () => {
            if (fromParam?.finish) {
              fromParam.finish(fromParam, false, true);
            }
          })
        }
      }
    };
    return customAnimation;
  }
}