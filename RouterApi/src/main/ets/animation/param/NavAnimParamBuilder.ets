import { NavAnimationModifier } from '../modifier/NavAnimationModifier'
import { NavAnimationMgr } from '../NavAnimationMgr'
import { INavAnimationParam } from './INavAnimationParam'

/**
 * @author: HHBin
 * @date: 2024-11-15
 * @desc: 路由动画转场参数建造器
 */
export class NavAnimParamBuilder {
  private _modifier: NavAnimationModifier
  private _ctx: NavDestinationContext
  private _param: INavAnimationParam = {}
  private _animateParam?: AnimateParam
  private _startTranslateOptions?: TranslateOptions
  private _endTranslateOptions?: TranslateOptions
  private _startScaleOptions?: ScaleOptions
  private _endScaleOptions?: ScaleOptions
  private _startRotateOptions?: RotateOptions
  private _endRotateOptions?: RotateOptions
  private _startOpacity?: number | Resource | undefined
  private _endOpacity?: number | Resource | undefined

  constructor(modifier: NavAnimationModifier, ctx: NavDestinationContext) {
    this._modifier = modifier
    this._ctx = ctx
  }

  public static builder(modifier: NavAnimationModifier, ctx: NavDestinationContext) {
    return new NavAnimParamBuilder(modifier, ctx)
  }

  public setAnimateParam(param: AnimateParam): NavAnimParamBuilder {
    this._animateParam = param
    return this
  }

  public translateStart(param: TranslateOptions): NavAnimParamBuilder {
    this._startTranslateOptions = param
    return this
  }

  public translateEnd(param: TranslateOptions): NavAnimParamBuilder {
    this._endTranslateOptions = param
    return this
  }

  public scaleStart(param: ScaleOptions): NavAnimParamBuilder {
    this._startScaleOptions = param
    return this
  }

  public scaleEnd(param: ScaleOptions): NavAnimParamBuilder {
    this._startScaleOptions = param
    return this
  }

  public rotateStart(param: RotateOptions): NavAnimParamBuilder {
    this._startRotateOptions = param
    return this
  }

  public rotateEnd(param: RotateOptions): NavAnimParamBuilder {
    this._endRotateOptions = param
    return this
  }

  public opacityStart(param: number | Resource | undefined): NavAnimParamBuilder {
    this._startOpacity = param
    return this
  }

  public opacityEnd(param: number | Resource | undefined): NavAnimParamBuilder {
    this._endOpacity = param
    return this
  }

  public build() {
    this._param.animateParam = this._animateParam
    this._param.startTranslateOptions = this._startTranslateOptions
    this._param.endTranslateOptions = this._endTranslateOptions
    this._param.startScaleOptions = this._startScaleOptions
    this._param.endScaleOptions = this._endScaleOptions
    this._param.startRotateOptions = this._startRotateOptions
    this._param.endRotateOptions = this._endRotateOptions
    this._param.startOpacity = this._startOpacity
    this._param.endOpacity = this._endOpacity
    NavAnimationMgr.getInstance().registerAnimParam(this._modifier, this._ctx, this._param)
  }
}