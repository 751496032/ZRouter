/**
 * @author: HHBin
 * @date: 2024-11-10
 * @desc:
 */
import { NavAnimationModifier } from './modifier/NavAnimationModifier';
import { INavSingleAnimationParam } from './param/INavAnimationParam';
import { NavAnimParamBuilder } from './param/NavAnimParamBuilder';
import { util } from '@kit.ArkTS';

// 自定义接口，用来保存某个页面相关的转场动画回调和参数
export interface AnimateCallback {
  modifier?: NavAnimationModifier | undefined
  // 进入状态(PUSH) 进入页的动画转场参数（A进入B 的 B进入转场）
  pushEnterParam?: INavSingleAnimationParam | undefined
  // 进入状态(PUSH) 离开页的动画转场参数（A进入B 的 A离开转场）
  pushExitParam?: INavSingleAnimationParam | undefined
  // 退出状态(POP) 进入页的动画转场参数（B返回A 的 A进入转场）
  popEnterParam?: INavSingleAnimationParam | undefined
  // 退出状态(POP) 离开页的动画转场参数（B返回A 的 B离开转场）
  popExitParam?: INavSingleAnimationParam | undefined
}

export interface NavAnimatePageInfo {
  pageId?: string
  modifier: NavAnimationModifier
}

/**
 * 转场动画管理器
 */
export class NavAnimationMgr {
  private static delegate = new NavAnimationMgr();

  private constructor() {
  }

  static getInstance(): NavAnimationMgr {
    return NavAnimationMgr.delegate;
  }

  /**
   * 该页面的动画转场所需要的modifier，也可以自己传进去
   * @param component
   * @param modifier
   * @returns
   */
  public modifier(component: object, modifier?: NavAnimationModifier): NavAnimationModifier {
    return NavAnimationStore.getInstance().modifier(component, modifier)
  }

  /**
   * 全局转场动画构造器，构造后还是需要给页面设置NavAnimationModifier，不然不生效
   * @returns
   */
  public defaultAnimateBuilder(): NavAnimParamBuilder {
    return NavAnimationStore.getInstance().defaultAnimateBuilder()
  }

  /**
   * 注册路由转场动画，设置相关参数
   * @param modifier
   * @param ctx
   * @param param
   */
  public registerAnimParam(component: object, ctx: NavDestinationContext): NavAnimParamBuilder {
    return NavAnimationStore.getInstance().buildAnimParam(component, ctx)
  }

  /**
   * 如果已经注册了路由动画，则获取动画参数构建器，没注册则返回空
   * @param modifier
   */
  public getAnimParamBuilder(component: object): NavAnimParamBuilder | undefined {
    return NavAnimationStore.getInstance().getAnimParamBuilder(component)
  }

  /**
   * 取消注册路由转场动画
   * @param modifier
   */
  public unregisterAnim(component: object): void {
    NavAnimationStore.getInstance().unregisterAnim(component)
  }

  /**
   * 自定义转场动画回调，在Navigation().customNavContentTransition()设置
   * @returns
   */
  public getAnimCustomNavContentTransition() {
    return NavAnimationStore.customNavContentTransition
  }
}

/**
 * 路由转场动画管理
 */
export class NavAnimationStore {
  private static delegate = new NavAnimationStore();
  private interactive: boolean = false;
  private proxy: NavigationTransitionProxy | undefined = undefined;
  private operation: NavigationOperation = NavigationOperation.PUSH
  // 根据 页面对象唯一标识 设置/获取 modifier 和 pageId
  private navContextMap: Map<string, NavAnimatePageInfo> = new Map();
  // 根据 pageId 设置/获取 转场动画
  private customTransitionMap: Map<string, AnimateCallback> = new Map();
  private _defaultCallback?: AnimateCallback

  static getInstance() {
    return NavAnimationStore.delegate;
  }

  /**
   * 该页面的动画转场所需要的modifier，也可以自己传进去
   * @param component
   * @param modifier
   * @returns
   */
  modifier(component: object, modifier?: NavAnimationModifier) {
    const pageInfo = this.navContextMap.get(this.getKey(component))
    if (pageInfo) {
      return pageInfo.modifier
    }
    const m = modifier ?? new NavAnimationModifier()
    this.navContextMap.set(this.getKey(component), { modifier: m })
    return m
  }

  private getKey(component: object) {
    return `${component.constructor.name}-${util.getHash(component)}`
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
  public registerAnimParam(component: object, ctx: NavDestinationContext): AnimateCallback | undefined {
    if (ctx.navDestinationId) {
      const pageInfo = this.navContextMap.get(this.getKey(component))
      if (pageInfo) {
        pageInfo.pageId = ctx.navDestinationId
        const name = ctx.navDestinationId;
        let param = this.customTransitionMap.get(name)
        if (!param) {
          param = {
            modifier: pageInfo?.modifier,
          }
          this.customTransitionMap.set(name, param);
        }
        return param
      }
    }
    return undefined
  }

  /**
   * 注册路由转场动画，相关参数构建
   * @param modifier
   * @param ctx
   */
  buildAnimParam(component: object, ctx: NavDestinationContext): NavAnimParamBuilder {
    const callback = this.registerAnimParam(component, ctx)
    return NavAnimParamBuilder.builder(callback)
  }


  /**
   * 如果已经注册了路由动画，则获取动画参数构建器，没注册则返回空
   * @param modifier
   */
  getAnimParamBuilder(component: object): NavAnimParamBuilder | undefined {
    const ctx = this.navContextMap.get(this.getKey(component))
    if (ctx?.pageId) {
      const callback = this.customTransitionMap.get(ctx?.pageId)
      if (callback) {
        return NavAnimParamBuilder.builder(callback)
      }
    }
    return undefined
  }

  /**
   * 取消注册路由转场动画
   * @param modifier
   */
  unregisterAnim(component: object) {
    const navId = this.navContextMap.get(this.getKey(component))?.pageId
    if (navId) {
      this.customTransitionMap.delete(navId);
    }
    this.navContextMap.delete(this.getKey(this))
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
    const proxy = NavAnimationStore.getInstance().getProxy()
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
          expectedFrameRateRange: param?.animateParam?.expectedFrameRateRange ?? {
            min: 60,
            expected: 90,
            max: 120,
          },
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

  // 自定义转场动画回调，在Navigation().customNavContentTransition()设置
  static customNavContentTransition = (from: NavContentInfo, to: NavContentInfo, operation: NavigationOperation) => {
    // if (from.mode == NavDestinationMode.DIALOG || to.mode == NavDestinationMode.DIALOG) {
    //   return undefined;
    // }

    const builder = NavAnimationStore.getInstance()
    const fromParam = builder.getAnimateParam(from.navDestinationId)
    const toParam = builder.getAnimateParam(to.navDestinationId)

    const toNoAnim = (!toParam?.pushEnterParam || !toParam?.pushEnterParam?.startCallback)
      && (!builder._defaultCallback?.pushEnterParam || !builder._defaultCallback?.pushEnterParam?.startCallback)
    const toNoModifier = !toParam?.modifier
    const fromNoAnim = (!fromParam?.popExitParam || !fromParam?.popExitParam?.startCallback)
      && (!builder._defaultCallback?.popExitParam || !builder._defaultCallback?.popExitParam?.startCallback)
    const fromNoModifier = !fromParam?.modifier
    if (operation == NavigationOperation.PUSH && (toNoAnim || toNoModifier)) {
      // 从 A页 进入 B页 时 B页 的进场动画转场不存在，或者 B页 的modifier不存在，则默认官方转场
      return undefined
    } else if (operation == NavigationOperation.POP && (fromNoAnim || fromNoModifier)) {
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
        builder.proxy?.finishTransition()
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