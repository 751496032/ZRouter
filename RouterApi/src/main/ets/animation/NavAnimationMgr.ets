/**
 * @author: HHBin
 * @date: 2024-11-10
 * @desc:
 */
import { NavAnimationModifier } from './modifier/NavAnimationModifier';
import { INavSingleAnimationParam } from './param/INavAnimationParam';
import { NavAnimParamBuilder } from './param/NavAnimParamBuilder';
import { util } from '@kit.ArkTS';
import { componentSnapshot, display, window } from '@kit.ArkUI';
import { WindowUtility } from './param/shared/utils/WindowUtility';
import { WindowUtils } from './param/shared/utils/WindowUtils';
import { ZRouter } from '../api/Router';
import { image } from '@kit.ImageKit';
import { SnapShotImage } from './param/shared/utils/SnapShotImage';
import { ObjectOrNull } from '../model/Model';
import { NavDestBuilder } from '../model/NavDestBuilder';
import { CardSharedAnimationProperties } from './param/shared/CardSharedAnimationProperties';
import { CardSharedAnimationOptions } from './param/shared/CardSharedAnimationOptions';
import { CardUtil } from './param/shared/utils/CardUtil';

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

export interface SharedCardParams {
  imageRes: ResourceStr,
  componentId: string | undefined,
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

  public getSharedCardAnimationProperties(): CardSharedAnimationProperties | undefined {
    return NavAnimationStore.getInstance().getSharedCardAnimationProperties()
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

  public initSharedAnim(windowStage: window.WindowStage) {
    NavAnimationStore.getInstance().initSharedAnim(windowStage)
  }

  public setNavigation(navigation: NavDestBuilder<ObjectOrNull>): NavAnimationStore {
    return NavAnimationStore.getInstance().setNavigation(navigation)
  }

  public withSharedCardParams(param: SharedCardParams): NavAnimationStore {
    return NavAnimationStore.getInstance().withSharedCardParams(param)
  }

  /**
   * 页面跳转
   * @param name 页面路由名称
   */
  public push(name: string) {
    NavAnimationStore.getInstance().push(name)
  }

  public sharedCard(): NavSharedCardAnimMgr {
    return new NavSharedCardAnimMgr()
  }
}

/**
 * 卡片一镜到底转场动画管理器
 */
export class NavSharedCardAnimMgr {
  private _navBgColor: ResourceColor | undefined = undefined
  private _isAdaptImmersive: boolean = false

  /**
   * 注册卡片一镜到底转场动画
   * @param component
   * @param ctx
   * @returns
   */
  public registerSharedCardAnimParam(component: object, ctx: NavDestinationContext): NavAnimParamBuilder {
    return NavAnimationStore.getInstance()
      .buildSharedCardAnimParam(component, ctx, this._navBgColor, this._isAdaptImmersive)
  }

  /**
   * 取消注册卡片一镜到底转场动画
   * @param component
   */
  public unregisterSharedCardAnim(component: object) {
    NavAnimationStore.getInstance().unregisterSharedCardAnim(component)
  }

  /**
   * 获取卡片图片资源
   * @returns
   */
  public getSharedUrl(): ResourceStr {
    let imageResource = ZRouter.getParamByKey(CardUtil.KEY_IMAGE_RESOURCE) as ResourceStr;
    return imageResource;
  }

  /**
   * 获取卡片点击的组件id
   * @returns
   */
  public getSharedComponentId(): string | undefined {
    let prePageCardId = ZRouter.getParamByKey(CardUtil.KEY_CLICKED_COMPONENT_ID) as string;
    return CardUtil.getPostPageImageId(prePageCardId);
  }

  /**
   * 获取屏幕宽度
   * @returns
   */
  public getWindowWidthPx(): number {
    return WindowUtils.windowWidth_px
  }

  /**
   * 获取屏幕高度
   * @returns
   */
  public getWindowHeightPx(): number {
    return WindowUtils.windowHeight_px
  }

  /**
   * 获取顶部安全区域高度
   * @returns
   */
  public getTopAvoidAreaHeightPx(): number {
    return WindowUtils.topAvoidAreaHeight_px
  }

  /**
   * 获取导航栏高度
   * @returns
   */
  public getNavigationIndicatorHeightPx(): number {
    return WindowUtils.navigationIndicatorHeight_px
  }

  /**
   * 获取控件截图
   * @returns
   */
  public getPixelMap(): image.PixelMap | undefined {
    return SnapShotImage.pixelMap
  }

  /**
   * 设置背景色
   * @param color 颜色
   * @returns
   */
  public setNavBgColor(color: ResourceColor) {
    this._navBgColor = color
    return this
  }

  /**
   * 设置是否适配沉浸式，如果页面是沉浸式，则设置为true
   * @param b
   */
  public setIsAdaptImmersive(b: boolean) {
    this._isAdaptImmersive = b
    return this
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
  private currentBreakPoint: string = '';
  private navigation: NavDestBuilder<ObjectOrNull> | undefined = undefined
  private cardSharedAnimPropMap: Map<string, CardSharedAnimationProperties> = new Map();
  private curComponent: Object | undefined
  private sharedCardParams: SharedCardParams | undefined = undefined

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

  getSharedCardAnimationProperties(): CardSharedAnimationProperties | undefined {
    if (!this.curComponent) {
      return undefined
    }
    return this.cardSharedAnimPropMap.get(this.getKey(this.curComponent))
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
        // 直接调用param?.animateParam?.expectedFrameRateRange，在Arkui-X上会报'expectedFrameRateRange' can't support crossplatform application.
        const expected =
          (param?.animateParam as Record<string, Object> | undefined)?.["expectedFrameRateRange"] as ExpectedFrameRateRange | undefined
        animateTo({
          duration: param?.animateParam?.duration,
          tempo: param?.animateParam?.tempo,
          curve: param?.animateParam?.curve,
          delay: param?.animateParam?.delay,
          iterations: param?.animateParam?.iterations,
          playMode: param?.animateParam?.playMode,
          finishCallbackType: param?.animateParam?.finishCallbackType,
          expectedFrameRateRange: expected ?? {
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

  initSharedAnim(windowStage: window.WindowStage) {
    WindowUtility.setWindow(windowStage)
    WindowUtils.window = windowStage.getMainWindowSync();
    WindowUtils.windowWidth_px = WindowUtils.window.getWindowProperties().windowRect.width;
    WindowUtils.windowHeight_px = WindowUtils.window.getWindowProperties().windowRect.height;
    this.updateBreakpoint(WindowUtils.windowWidth_px);
    let avoidArea = WindowUtils.window.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    WindowUtils.topAvoidAreaHeight_px = avoidArea.topRect.height;
    let navigationArea = WindowUtils.window.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
    WindowUtils.navigationIndicatorHeight_px = navigationArea.bottomRect.height;
    try {
      WindowUtils.window.on('windowSizeChange', (data) => {
        WindowUtils.windowWidth_px = data.width;
        WindowUtils.windowHeight_px = data.height;
        this.updateBreakpoint(data.width);
      })
      WindowUtils.window.on('avoidAreaChange', (data) => {
        if (data.type === window.AvoidAreaType.TYPE_SYSTEM) {
          let topRectHeight = data.area.topRect.height;
          WindowUtils.topAvoidAreaHeight_px = topRectHeight;
        } else if (data.type === window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR) {
          let bottomRectHeight = data.area.bottomRect.height;
          WindowUtils.navigationIndicatorHeight_px = bottomRectHeight;
        }
      })
    } catch (exception) {
      console.error(exception)
    }
  }

  updateBreakpoint(width: number) {
    let windowWidthVp = width / (display.getDefaultDisplaySync().densityDPI / 160);
    let newBreakPoint: string = '';
    if (windowWidthVp < 400) {
      newBreakPoint = 'xs';
    } else if (windowWidthVp < 600) {
      newBreakPoint = 'sm';
    } else if (windowWidthVp < 800) {
      newBreakPoint = 'md';
    } else {
      newBreakPoint = 'lg';
    }
    if (this.currentBreakPoint !== newBreakPoint) {
      this.currentBreakPoint = newBreakPoint;
      // Record the current breakpoint value using the state variable.
      AppStorage.setOrCreate('currentBreakpoint', this.currentBreakPoint);
    }
  }

  public withSharedCardParams(param: SharedCardParams): NavAnimationStore {
    this.sharedCardParams = param
    return this
  }

  public setNavigation(navigation: NavDestBuilder<ObjectOrNull>): NavAnimationStore {
    this.navigation = navigation
    return this
  }

  buildSharedCardAnimParam(
    component: object,
    ctx: NavDestinationContext,
    navBgColor: ResourceColor | undefined,
    isAdaptImmersive: boolean
  ): NavAnimParamBuilder {
    const prop = new CardSharedAnimationProperties()
    prop.registerSharedCardAnim()
    this.cardSharedAnimPropMap.set(this.getKey(component), prop)
    this.curComponent = component
    return ZRouter.animateMgr()
      .registerAnimParam(component, ctx)
      .addAnimateOptions(new CardSharedAnimationOptions(prop, navBgColor, isAdaptImmersive));
  }

  unregisterSharedCardAnim(component: object) {
    this.unregisterAnim(component)
    this.cardSharedAnimPropMap.delete(this.getKey(component))
  }

  push(name: string) {
    const param = this.sharedCardParams
    if (!param) {
      return
    }
    componentSnapshot.get(param.componentId, (error: Error, pixelMap: image.PixelMap) => {
      if (error) {
        (this.navigation ?? ZRouter.getInstance()).push(name)
      } else {
        SnapShotImage.pixelMap = pixelMap;
        (this.navigation ?? ZRouter.getInstance())
          .withParam(CardUtil.KEY_IMAGE_RESOURCE, param.imageRes)
          .withParam(CardUtil.KEY_CLICKED_COMPONENT_ID, param.componentId)
          .push(name)
      }
    })
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