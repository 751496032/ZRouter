/**
 * @author: HHBin
 * @date: 2024-11-10
 * @desc:
 */
// CustomNavigationUtils.ets
import { INavAnimationCallback } from './callback/INavAnimationCallback';
import { NavAnimationCallback } from './callback/NavAnimationCallback';
import { NavAnimationModifier } from './modifier/NavAnimationModifier';
import { EmptyNavAnimationParam } from './param/EmptyNavAnimationParam';
import { INavAnimationParam } from './param/INavAnimationParam';

// 自定义接口，用来保存某个页面相关的转场动画回调和参数
export interface AnimateCallback {
  modifier: NavAnimationModifier
  param: INavAnimationParam
  finish: ((options: AnimateCallback, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  start: ((options: AnimateCallback, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  onFinish: ((options: AnimateCallback, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  interactive: ((options: AnimateCallback, operation: NavigationOperation) => void | undefined) | undefined;
  update: ((options: NavAnimationModifier) => void | undefined) | undefined
  timeout: (number | undefined) | undefined;
}

const customTransitionMap: Map<string, AnimateCallback> = new Map();

/**
 * 路由转场动画管理
 */
export class NavAnimationMgr {
  static delegate = new NavAnimationMgr();
  interactive: boolean = true;
  proxy: NavigationTransitionProxy | undefined = undefined;
  operation: NavigationOperation = NavigationOperation.PUSH
  callback: AnimateCallback | undefined
  private navContextMap: Map<object, NavDestinationContext> = new Map();

  static getInstance() {
    return NavAnimationMgr.delegate;
  }

  /**
   * 注册路由转场动画，设置相关参数（推荐）
   * @param component
   * @param ctx
   * @param param
   */
  public registerAnimParam(component: object, ctx: NavDestinationContext, param: INavAnimationParam): void {
    const options = new NavAnimationCallback(param.update)
    options.param = param
    if (param.timeout) {
      options.timeout = options.timeout
    }
    this.registerAnimCallback(component, ctx, options);
  }

  /**
   * 注册路由转场动画，设置相关回调，如果要实现复杂的动画效果可以通过自定义INavAnimationCallback来实现
   * @param component
   * @param ctx
   * @param options
   */
  public registerAnimCallback(component: object, ctx: NavDestinationContext, options: INavAnimationCallback): void {
    if (ctx.navDestinationId && !this.navContextMap.has(component)) {
      this.updateOptions(options)
      this.navContextMap.set(component, ctx)
      options.name = ctx.navDestinationId;
      if (options.name) {
        if (customTransitionMap.has(options.name)) {
          let param = customTransitionMap.get(options.name);
          if (param !== undefined) {
            param.modifier = options.modifier ?? new NavAnimationModifier()
            param.param = options.param ?? new EmptyNavAnimationParam()
            param.start = options.startCallback;
            param.finish = options.endCallback;
            param.timeout = options.timeout;
            param.update = options.update;
            param.onFinish = options.onFinish;
            param.interactive = options.interactiveCallback;

            param.modifier.callback = param
          }
        }
        let params: AnimateCallback = {
          modifier: new NavAnimationModifier(),
          param: options.param ?? new EmptyNavAnimationParam(),
          timeout: options.timeout,
          start: options.startCallback,
          finish: options.endCallback,
          update: options.update,
          onFinish: options.onFinish,
          interactive: options.interactiveCallback
        };

        params.modifier.callback = params
        customTransitionMap.set(options.name, params);
      }
    }
  }

  private updateOptions(options: INavAnimationCallback) {
    const param = options.param
    if (param) {
      if (param.timeout) {
        options.timeout = param.timeout
      }
      if (param.update) {
        options.update = param.update
      }
    }
  }

  unregisterAnim(component: object) {
    if (this.navContextMap.has(component)) {
      const navId = this.navContextMap.get(component)?.navDestinationId
      if (navId) {
        customTransitionMap.delete(navId);
      }
      this.navContextMap.delete(component)
    }
  }

  fireInteractiveAnimation(id: string, callback: AnimateCallback, operation: NavigationOperation) {
    this.callback = callback
    let animation = customTransitionMap.get(id)?.interactive;
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
    let fromParam = customTransitionMap.get(this.proxy.from.navDestinationId);
    if (fromParam?.onFinish) {
      fromParam.onFinish(fromParam, false, false);
    }
    let toParam = customTransitionMap.get(this.proxy?.to.navDestinationId);
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
      modifier: customTransitionMap.get(name)?.modifier ?? new NavAnimationModifier(),
      param: customTransitionMap.get(name)?.param ?? new EmptyNavAnimationParam(),
      start: customTransitionMap.get(name)?.start,
      finish: customTransitionMap.get(name)?.finish,
      update: customTransitionMap.get(name)?.update,
      timeout: customTransitionMap.get(name)?.timeout,
      onFinish: customTransitionMap.get(name)?.onFinish,
      interactive: customTransitionMap.get(name)?.interactive,
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
                if (callback.timeout) {
                  customAnimation.timeout = callback.timeout
                }
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
            builder.callback = toParam
            if (toParam.timeout) {
              customAnimation.timeout = toParam.timeout
            }
            toParam.start(toParam, true, false);
          }
          animateTo({
            duration: 500, onFinish: () => {
              transitionProxy.finishTransition();
            }
          }, () => {
            if (toParam?.finish) {
              builder.callback = toParam
              toParam.finish(toParam, true, false);
            }
          })
        } else {
          if (fromParam?.start) {
            builder.callback = fromParam
            if (fromParam.timeout) {
              customAnimation.timeout = fromParam.timeout
            }
            fromParam.start(fromParam, false, true);
          }
          animateTo({
            duration: 500, onFinish: () => {
              transitionProxy.finishTransition();
            }
          }, () => {
            if (fromParam?.finish) {
              builder.callback = fromParam
              fromParam.finish(fromParam, false, true);
            }
          })
        }
      }
    };
    return customAnimation;
  }
}