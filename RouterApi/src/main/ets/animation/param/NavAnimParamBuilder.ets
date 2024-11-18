import { NavAnimationModifier } from '../modifier/NavAnimationModifier'
import { AnimateCallback, NavAnimationMgr } from '../NavAnimationMgr'
import { INavSingleAnimationParam } from './INavAnimationParam'

/**
 * @author: HHBin
 * @date: 2024-11-15
 * @desc: 路由动画转场参数建造器
 */
// const PUSH_ENTER = 1
// const PUSH_EXIT = 2
// const POP_ENTER = 3
// const POP_EXIT = 4

export class NavAnimParamBuilder {
  private _modifier: NavAnimationModifier
  private _ctx: NavDestinationContext
  private _param?: AnimateCallback
  private _pushEnterParam?: INavSingleAnimationParam
  private _pushExitParam?: INavSingleAnimationParam
  private _popEnterParam?: INavSingleAnimationParam
  private _popExitParam?: INavSingleAnimationParam
  // private _status = PUSH_ENTER

  constructor(modifier: NavAnimationModifier, ctx: NavDestinationContext) {
    this._modifier = modifier
    this._ctx = ctx
    this._param = NavAnimationMgr.getInstance().registerAnimParam(this._modifier, this._ctx)
  }

  /**
   * 动画构建器
   * @param modifier
   * @param ctx
   * @returns
   */
  public static builder(modifier: NavAnimationModifier, ctx: NavDestinationContext): NavAnimParamBuilder {
    return new NavAnimParamBuilder(modifier, ctx)
  }

  /**
   * 进入状态(PUSH) 进入页的动画转场参数（A进入B 的 B进入转场）
   * @param param
   * @returns
   */
  public setPushEnterAnimate(param: INavSingleAnimationParam) {
    if (!this._pushEnterParam) {
      this._pushEnterParam = param
      if (this._param) {
        this._param.pushEnterParam = this._pushEnterParam
      }
    }
    return this
  }

  /**
   * 进入状态(PUSH) 离开页的动画转场参数（A进入B 的 A离开转场）
   * @param param
   * @returns
   */
  public setPushExitAnimate(param: INavSingleAnimationParam) {
    if (!this._pushExitParam) {
      this._pushExitParam = param
      if (this._param) {
        this._param.pushExitParam = this._pushExitParam
      }
    }
    return this
  }

  /**
   * 退出状态(POP) 进入页的动画转场参数（B返回A 的 A进入转场）
   * @param param
   * @returns
   */
  public setPopEnterAnimate(param: INavSingleAnimationParam) {
    if (!this._popEnterParam) {
      this._popEnterParam = param
      if (this._param) {
        this._param.popEnterParam = this._popEnterParam
      }
    }
    return this
  }

  /**
   * 退出状态(POP) 离开页的动画转场参数（B返回A 的 B离开转场）
   * @param param
   * @returns
   */
  public setPopExitAnimate(param: INavSingleAnimationParam) {
    if (!this._popExitParam) {
      this._popExitParam = param
      if (this._param) {
        this._param.popExitParam = this._popExitParam
      }
    }
    return this
  }

  // /**
  //  * 切换：进入状态(PUSH) 进入页的动画转场参数（A进入B 的 B进入转场）
  //  * @returns
  //  */
  // public animatePushEnter() {
  //   this._status = PUSH_ENTER
  //   return this
  // }
  //
  // /**
  //  * 切换：进入状态(PUSH) 离开页的动画转场参数（A进入B 的 A离开转场）
  //  * @returns
  //  */
  // public animatePushExit() {
  //   this._status = PUSH_EXIT
  //   return this
  // }
  //
  // /**
  //  * 切换：退出状态(POP) 进入页的动画转场参数（B返回A 的 A进入转场）
  //  * @returns
  //  */
  // public animatePopEnter() {
  //   this._status = POP_ENTER
  //   return this
  // }
  //
  // /**
  //  * 切换：退出状态(POP) 离开页的动画转场参数（B返回A 的 B离开转场）
  //  * @returns
  //  */
  // public animatePopExit() {
  //   this._status = POP_EXIT
  //   return this
  // }
  //
  // /**
  //  * 设置转场动画函数参数
  //  * @param param
  //  * @returns
  //  */
  // public setAnimateParam(param: AnimateParam) {
  //   this.getParam().animateParam = param
  //   return this
  // }
  //
  // /**
  //  * 设置起点平移果参数
  //  * @param param
  //  * @returns
  //  */
  // public translateStart(param: TranslateOptions) {
  //   this.getParam().startTranslateOptions = param
  //   return this
  // }
  //
  // /**
  //  * 终点平移参数
  //  * @param param
  //  * @returns
  //  */
  // public translateEnd(param: TranslateOptions) {
  //   this.getParam().endTranslateOptions = param
  //   return this
  // }
  //
  // /**
  //  * 起点缩放参数
  //  * @param param
  //  * @returns
  //  */
  // public scaleStart(param: ScaleOptions) {
  //   this.getParam().startScaleOptions = param
  //   return this
  // }
  //
  // /**
  //  * 终点缩放参数
  //  * @param param
  //  * @returns
  //  */
  // public scaleEnd(param: ScaleOptions) {
  //   this.getParam().endScaleOptions = param
  //   return this
  // }
  //
  // /**
  //  * 起点旋转参数
  //  * @param param
  //  * @returns
  //  */
  // public rotateStart(param: RotateOptions) {
  //   this.getParam().startRotateOptions = param
  //   return this
  // }
  //
  // /**
  //  * 终点旋转参数
  //  * @param param
  //  * @returns
  //  */
  // public rotateEnd(param: RotateOptions) {
  //   this.getParam().endRotateOptions = param
  //   return this
  // }
  //
  // /**
  //  * 起点透明度值参数
  //  * @param param
  //  * @returns
  //  */
  // public opacityStart(param: number | Resource | undefined) {
  //   this.getParam().startOpacity = param
  //   return this
  // }
  //
  // /**
  //  * 终点透明度值参数
  //  * @param param
  //  * @returns
  //  */
  // public opacityEnd(param: number | Resource | undefined) {
  //   this.getParam().endOpacity = param
  //   return this
  // }
  //
  // private getParam(): INavSingleAnimationParam {
  //   switch (this._status) {
  //     case PUSH_EXIT:
  //       if (!this._pushExitParam) {
  //         this._pushExitParam = {}
  //         if (this._param) {
  //           this._param.pushExitParam = this._pushExitParam
  //         }
  //       }
  //       return this._pushExitParam
  //     case POP_ENTER:
  //       if (!this._popEnterParam) {
  //         this._popEnterParam = {}
  //         if (this._param) {
  //           this._param.popEnterParam = this._popEnterParam
  //         }
  //       }
  //       return this._popEnterParam
  //     case POP_EXIT:
  //       if (!this._popExitParam) {
  //         this._popExitParam = {}
  //         if (this._param) {
  //           this._param.popExitParam = this._popExitParam
  //         }
  //       }
  //       return this._popExitParam
  //     case PUSH_ENTER:
  //     default:
  //       if (!this._pushEnterParam) {
  //         this._pushEnterParam = {}
  //         if (this._param) {
  //           this._param.pushEnterParam = this._pushEnterParam
  //         }
  //       }
  //       return this._pushEnterParam
  //
  //   }
  // }
}