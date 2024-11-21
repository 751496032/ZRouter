import { NavAnimationModifier } from '../modifier/NavAnimationModifier'
import { AnimateCallback, NavAnimationMgr } from '../NavAnimationMgr'
import { INavSingleAnimationParam } from './INavAnimationParam'

/**
 * @author: HHBin
 * @date: 2024-11-15
 * @desc: 路由动画转场参数建造器
 */
export class NavAnimParamBuilder {
  private _callback?: AnimateCallback
  private _pushEnterParam?: INavSingleAnimationParam
  private _pushExitParam?: INavSingleAnimationParam
  private _popEnterParam?: INavSingleAnimationParam
  private _popExitParam?: INavSingleAnimationParam

  constructor(callback?: AnimateCallback) {
    if (callback) {
      this._callback =callback
    } else {
      this._callback = {}
    }
  }

  /**
   * 动画构建器
   * @param modifier
   * @param ctx
   * @returns
   */
  public static builder(callback?: AnimateCallback): NavAnimParamBuilder {
    return new NavAnimParamBuilder(callback)
  }

  public getCallback(): AnimateCallback | undefined {
    return this._callback
  }

  /**
   * 进入状态(PUSH) 进入页的动画转场参数（A进入B 的 B进入转场）
   * @param param
   * @returns
   */
  public setPushEnterAnimate(param: INavSingleAnimationParam) {
    if (!this._pushEnterParam) {
      this._pushEnterParam = param
      if (this._callback) {
        this._callback.pushEnterParam = this._pushEnterParam
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
      if (this._callback) {
        this._callback.pushExitParam = this._pushExitParam
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
      if (this._callback) {
        this._callback.popEnterParam = this._popEnterParam
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
      if (this._callback) {
        this._callback.popExitParam = this._popExitParam
      }
    }
    return this
  }
}