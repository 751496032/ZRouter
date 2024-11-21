/**
 * @author: HHBin
 * @date: 2024-11-10
 * @desc:
 */
import { NavAnimationModifier } from './modifier/NavAnimationModifier';
import { INavSingleAnimationParam } from './param/INavAnimationParam';
import { NavAnimParamBuilder } from './param/NavAnimParamBuilder';

// 自定义接口，用来保存某个页面相关的转场动画回调和参数
export interface AnimateCallback {
  modifier?: NavAnimationModifier | undefined
  pushEnterParam?: INavSingleAnimationParam | undefined
  pushExitParam?: INavSingleAnimationParam | undefined
  popEnterParam?: INavSingleAnimationParam | undefined
  popExitParam?: INavSingleAnimationParam | undefined
}

/**
 * 路由转场动画管理
 */
export class NavAnimationMgr {
  private static delegate = new NavAnimationMgr();
  private interactive: boolean = false;
  private proxy: NavigationTransitionProxy | undefined = undefined;
  private operation: NavigationOperation = NavigationOperation.PUSH
  private navContextMap: Map<NavAnimationModifier, NavDestinationContext> = new Map();
  private customTransitionMap: Map<string, AnimateCallback> = new Map();
  private _defaultCallback?: AnimateCallback

  static getInstance() {
    return NavAnimationMgr.delegate;
  }

  /**
   * 全局转场动画构造器，构造后还是需要给页面设置NavAnimationModifier，不然不生效
   * @returns
   */
  defaultAnimateBuilder() {
    const builder = NavAnimParamBuilder.builder()
    this._defaultCallback = builder.getCallback()
    return builder
  }

  /**
   * 注册路由转场动画，设置相关参数
   * @param modifier
   * @param ctx
   * @param param
   */
  public registerAnimParam(modifier: NavAnimationModifier, ctx: NavDestinationContext): AnimateCallback | undefined {
    if (ctx.navDestinationId && !this.navContextMap.has(modifier)) {
      this.navContextMap.set(modifier, ctx)
      const name = ctx.navDestinationId;
      let param: AnimateCallback | undefined
      if (!this.customTransitionMap.has(name)) {
        param = {
          modifier: modifier,
        }
        this.customTransitionMap.set(name, param);
      }
      return param
    }
    if (ctx.navDestinationId) {
      return this.customTransitionMap.get(ctx.navDestinationId)
    }
    return undefined
  }

  /**
   * 注册路由转场动画，相关参数构建
   * @param modifier
   * @param ctx
   */
  buildAnimParam(modifier: NavAnimationModifier, ctx: NavDestinationContext): NavAnimParamBuilder {
    const callback = this.registerAnimParam(modifier, ctx)
    return NavAnimParamBuilder.builder(callback)
  }


  /**
   * 如果已经注册了路由动画，则获取动画参数构建器，没注册则返回空
   * @param modifier
   */
  getAnimParamBuilder(modifier: NavAnimationModifier): NavAnimParamBuilder | undefined {
    const ctx = this.navContextMap.get(modifier)
    if (ctx?.navDestinationId) {
      const callback = this.customTransitionMap.get(ctx.navDestinationId)
      return NavAnimParamBuilder.builder(callback)
    }
    return undefined
  }

  /**
   * 取消注册路由转场动画
   * @param modifier
   */
  unregisterAnim(modifier: NavAnimationModifier) {
    const navId = this.navContextMap.get(modifier)?.navDestinationId
    if (navId) {
      this.customTransitionMap.delete(navId);
    }
    this.navContextMap.delete(modifier)
  }

  startNavAnimPushEnter(id: string | undefined) {
    const callback = this.getAnimateParam(id)
    if (callback?.modifier && callback.pushEnterParam) {
      this.update(callback.modifier, callback.pushEnterParam)
    } else if (callback?.modifier && this._defaultCallback) {
      this.update(callback.modifier, this._defaultCallback.pushEnterParam)
    } else {
      this.finishTransition()
    }
  }

  startNavAnimPushExit(id: string | undefined) {
    const callback = this.getAnimateParam(id)
    if (callback?.modifier && callback.pushExitParam) {
      this.update(callback.modifier, callback.pushExitParam)
    } else if (callback?.modifier && this._defaultCallback) {
      this.update(callback.modifier, this._defaultCallback.pushExitParam)
    }
  }

  startNavAnimPopEnter(id: string | undefined) {
    const callback = this.getAnimateParam(id)
    if (callback?.modifier && callback.popEnterParam) {
      this.update(callback.modifier, callback.popEnterParam)
    } else if (callback?.modifier && this._defaultCallback) {
      this.update(callback.modifier, this._defaultCallback.popEnterParam)
    }
  }

  startNavAnimPopExit(id: string | undefined) {
    const callback = this.getAnimateParam(id)
    if (callback?.modifier && callback.popExitParam) {
      this.update(callback.modifier, callback.popExitParam)
    } else if (callback?.modifier && this._defaultCallback) {
      this.update(callback.modifier, this._defaultCallback.popExitParam)
    } else {
      this.finishTransition()
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
        this.finishTransition();
      }
    } else {
      if (rate > 0.5) {
        this.finishTransition();
      } else {
        if (this.proxy?.cancelTransition) {
          this.proxy.cancelTransition();
        }
      }
    }
  }

  getAnimateParam(name: string | undefined): AnimateCallback | undefined {
    if (!name) {
      return undefined
    }
    if (!this.customTransitionMap.has(name)) {
      return undefined
    }
    let result: AnimateCallback = {
      modifier: this.customTransitionMap.get(name)?.modifier,
      pushEnterParam: this.customTransitionMap.get(name)?.pushEnterParam,
      pushExitParam: this.customTransitionMap.get(name)?.pushExitParam,
      popEnterParam: this.customTransitionMap.get(name)?.popEnterParam,
      popExitParam: this.customTransitionMap.get(name)?.popExitParam,
    };
    return result;
  }

  public getProxy(): NavigationTransitionProxy | undefined {
    return this.proxy
  }

  // 根据动画转场参数播放动画转场效果
  private update(modifier: NavAnimationModifier, param: INavSingleAnimationParam | undefined) {
    const proxy = NavAnimationMgr.getInstance().getProxy()
    if (param) {
      if (param.startCallback) {
        param.startCallback(modifier, proxy)
      }
      if (param.endCallback) {
        animateTo({
          duration: param?.animateParam?.duration,
          tempo: param?.animateParam?.tempo,
          curve: param?.animateParam?.curve,
          delay: param?.animateParam?.delay,
          iterations: param?.animateParam?.iterations,
          playMode: param?.animateParam?.playMode,
          finishCallbackType: param?.animateParam?.finishCallbackType,
          expectedFrameRateRange: param?.animateParam?.expectedFrameRateRange,
          onFinish: () => {
            if (param?.animateParam?.onFinish) {
              param?.animateParam.onFinish()
            }
            this.finishTransition()
          }
        }, () => {
          if (param.endCallback) {
            param.endCallback(modifier, proxy)
          }
        })
      }
    }
  }

  // 自定义导航内容过渡动画默认实现，在Navigation().customNavContentTransition()设置
  static customNavContentTransition = (from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation) => {
    // if (from.mode == NavDestinationMode.DIALOG || to.mode == NavDestinationMode.DIALOG) {
    //   return undefined;
    // }

    const builder = NavAnimationMgr.getInstance()
    const fromParam = builder.getAnimateParam(from.navDestinationId)
    const toParam = builder.getAnimateParam(to.navDestinationId)

    if (operation == NavigationOperation.PUSH
      && ((!toParam?.pushEnterParam && !builder._defaultCallback?.pushEnterParam) || !toParam?.modifier)) {
      // 从 A页 进入 B页 时 B页 的进场动画转场不存在，或者 B页 的modifier不存在，则默认官方转场
      return undefined
    } else if (operation == NavigationOperation.POP
      && ((!fromParam?.popExitParam && !builder._defaultCallback?.popExitParam) || !fromParam?.modifier)) {
      // 从 B页 退回 A页 时 B页 的退场动画转场不存在，或者 B页 的modifier不存在，则默认官方转场
      return undefined
    }

    builder.operation = operation;
    let customAnimation: NavigationAnimatedTransition = {
      timeout: 7000,
      onTransitionEnd: (isSuccess: boolean) => {
        console.log("===== current transition is " + isSuccess);
        builder.proxy = undefined;
      },
      transition: (transitionProxy: NavigationTransitionProxy) => {
        builder.proxy = transitionProxy;
        if (operation == NavigationOperation.PUSH) {
          // 从 A页 进入 B页 时 B页 的动画转场
          builder.startNavAnimPushEnter(to.navDestinationId);
          // 从 A页 进入 B页 时 A页 的动画转场
          builder.startNavAnimPushExit(from.navDestinationId);
        } else {
          // 从 B页 退回 A页 时 B页 的动画转场
          builder.startNavAnimPopExit(from.navDestinationId);
          // 从 B页 退回 A页 时 A页 的动画转场
          builder.startNavAnimPopEnter(to.navDestinationId);
        }
      },
      isInteractive: builder.interactive
    }
    return customAnimation;
  }
}