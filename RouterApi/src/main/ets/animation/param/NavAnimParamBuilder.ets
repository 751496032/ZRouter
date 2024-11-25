import { AnimateCallback, NavAnimationStore } from '../NavAnimationMgr'
import { INavAnimateOptions } from './INavAnimateOptions'
import {  NavAnimateOptions, INavSingleAnimationParam } from './INavAnimationParam'

/**
 * @author: HHBin
 * @date: 2024-11-15
 * @desc: 路由动画转场参数建造器
 */
export class NavAnimParamBuilder {
  private _callback: AnimateCallback
  private _options = new NavAnimateOptions()

  constructor(callback?: AnimateCallback) {
    if (callback) {
      this._callback = callback
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

  public setCustomAnimeOptions(options: NavAnimateOptions) {
    this._options = options
    this._options.update(this._callback)
    return this
  }

  /**
   * 设置进场动画参数（比如动画时间，播放速度等）
   * @param param
   * @returns
   */
  public setExitAnimate(param: AnimateParam) {
    this._options.setExitAnimateParam(param)
    this._options.update(this._callback)
    return this
  }

  /**
   * 添加动画，可以重复添加，动画效果会重叠在一起
   * @returns
   */
  public addAnimateOptions(options: INavAnimateOptions) {
    this._options.addOptions(options)
    this._options.update(this._callback)
    return this
  }

  /**
   * 设置退场动画参数（比如动画时间，播放速度等）
   * @param param
   * @returns
   */
  public setEnterAnimate(param: AnimateParam) {
    this._options.setEnterAnimateParam(param)
    this._options.update(this._callback)
    return this
  }

  /**
   * 进入状态(PUSH) 进入页的动画转场参数（A进入B 的 B进入转场）
   * @param param
   * @returns
   */
  public setPushEnterAnimate(param: INavSingleAnimationParam) {
    if (this._callback) {
      this._callback.pushEnterParam = param
    }
    return this
  }

  /**
   * 进入状态(PUSH) 离开页的动画转场参数（A进入B 的 A离开转场）
   * @param param
   * @returns
   */
  public setPushExitAnimate(param: INavSingleAnimationParam) {
    if (this._callback) {
      this._callback.pushExitParam = param
    }
    return this
  }

  /**
   * 退出状态(POP) 进入页的动画转场参数（B返回A 的 A进入转场）
   * @param param
   * @returns
   */
  public setPopEnterAnimate(param: INavSingleAnimationParam) {
    if (this._callback) {
      this._callback.popEnterParam = param
    }
    return this
  }

  /**
   * 退出状态(POP) 离开页的动画转场参数（B返回A 的 B离开转场）
   * @param param
   * @returns
   */
  public setPopExitAnimate(param: INavSingleAnimationParam) {
    if (this._callback) {
      this._callback.popExitParam = param
    }
    return this
  }

  /**
   * 自定义转场动画回调，在Navigation().customNavContentTransition()设置
   * @returns
   */
  public getAnimCustomNavContentTransition() {
    return NavAnimationStore.customNavContentTransition
  }
}