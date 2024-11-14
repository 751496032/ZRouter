/**
 * @author: HHBin
 * @date: 2024-11-10
 * @desc:
 */
// CustomNavigationUtils.ets
import { INavAnimationOptions } from './callback/INavAnimationOptions';
import { NavDestinationModifier } from '@kit.ArkUI';
import { NavAnimationModifier } from './modifier/NavAnimationModifier';

// 自定义接口，用来保存某个页面相关的转场动画回调和参数
export interface AnimateCallback {
  modifier: NavDestinationModifier | undefined
  finish: ((options: AnimateCallback, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  start: ((options: AnimateCallback, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  onFinish: ((options: AnimateCallback, isPush: boolean, isExit: boolean) => void | undefined) | undefined;
  interactive: ((options: AnimateCallback, operation: NavigationOperation) => void | undefined) | undefined;
  update: ((options: NavDestinationModifier) => void | undefined) | undefined
  timeout: (number | undefined) | undefined;
}

export interface NavAnimationLocation {
  x?: number | string;
  y?: number | string;
  z?: number | string;
}

const customTransitionMap: Map<string, AnimateCallback> = new Map();

export class NavAnimationMgr {
  static delegate = new NavAnimationMgr();
  interactive: boolean = true;
  proxy: NavigationTransitionProxy | undefined = undefined;
  operation: NavigationOperation = NavigationOperation.PUSH
  loc: NavAnimationLocation = {}
  callback: AnimateCallback | undefined
  private navContextMap: Map<object, NavDestinationContext> = new Map();

  static getInstance() {
    return NavAnimationMgr.delegate;
  }

  /* 注册某个页面的动画回调
   * name: 注册页面的唯一id
   * startCallback：用来设置动画开始时页面的状态
   * endCallback：用来设置动画结束时页面的状态
   * onFinish：用来执行动画结束后页面的其他操作
   * interactiveCallback: 注册的可交互转场的动效
   * timeout：转场结束的超时时间
   */
  public registerAnim(component: object, ctx: NavDestinationContext, options: INavAnimationOptions): void {
    if (ctx.navDestinationId && !this.navContextMap.has(component)) {
      this.navContextMap.set(component, ctx)
      options.name = ctx.navDestinationId;
      if (options.name) {
        if (customTransitionMap.has(options.name)) {
          let param = customTransitionMap.get(options.name);
          if (param !== undefined) {
            param.modifier = options.modifier ?? new NavAnimationModifier(param)
            param.start = options.startCallback;
            param.finish = options.endCallback;
            param.timeout = options.timeout;
            param.update = options.update;
            param.onFinish = options.onFinish;
            param.interactive = options.interactiveCallback;
            return;
          }
        }
        let params: AnimateCallback = {
          modifier: undefined,
          timeout: options.timeout,
          start: options.startCallback,
          finish: options.endCallback,
          update: options.update,
          onFinish: options.onFinish,
          interactive: options.interactiveCallback
        };
        params.modifier = options.modifier ?? new NavAnimationModifier(params)
        customTransitionMap.set(options.name, params);
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

  public updateLocation(loc: NavAnimationLocation) {
    if (loc.x) {
      this.loc.x = loc.x
    }
    if (loc.y) {
      this.loc.y = loc.y
    }
    if (loc.z) {
      this.loc.z = loc.z
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
      modifier: customTransitionMap.get(name)?.modifier,
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

    const builder = NavAnimationMgr.getInstance()

    builder.operation = operation;
    if (builder.interactive) {
      let customAnimation: NavigationAnimatedTransition = {
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
            builder.callback = toParam
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