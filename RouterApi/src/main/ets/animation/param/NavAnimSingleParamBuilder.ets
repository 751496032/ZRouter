import { INavSingleAnimationParam } from './INavAnimationParam'

/**
 * @author: HHBin
 * @date: 2024-11-19
 * @desc: 路由动画转场单一参数建造器
 */
export class NavAnimSingleParamBuilder {
  private _param: INavSingleAnimationParam

  constructor() {
    this._param = {}
  }

  /**
   * 动画构建器
   * @param modifier
   * @param ctx
   * @returns
   */
  public static builder(): NavAnimSingleParamBuilder {
    return new NavAnimSingleParamBuilder()
  }

  public build(): INavSingleAnimationParam {
    return this._param
  }

  /**
   * 设置转场动画函数参数
   * @param param
   * @returns
   */
  public setAnimateParam(param: AnimateParam) {
    this.getParam().animateParam = param
    return this
  }

  /**
   * 设置起点平移果参数
   * @param param
   * @returns
   */
  public translateStart(param: TranslateOptions) {
    this.getParam().startTranslateOptions = param
    return this
  }

  /**
   * 终点平移参数
   * @param param
   * @returns
   */
  public translateEnd(param: TranslateOptions) {
    this.getParam().endTranslateOptions = param
    return this
  }

  /**
   * 起点缩放参数
   * @param param
   * @returns
   */
  public scaleStart(param: ScaleOptions) {
    this.getParam().startScaleOptions = param
    return this
  }

  /**
   * 终点缩放参数
   * @param param
   * @returns
   */
  public scaleEnd(param: ScaleOptions) {
    this.getParam().endScaleOptions = param
    return this
  }

  /**
   * 起点旋转参数
   * @param param
   * @returns
   */
  public rotateStart(param: RotateOptions) {
    this.getParam().startRotateOptions = param
    return this
  }

  /**
   * 终点旋转参数
   * @param param
   * @returns
   */
  public rotateEnd(param: RotateOptions) {
    this.getParam().endRotateOptions = param
    return this
  }

  /**
   * 起点透明度值参数
   * @param param
   * @returns
   */
  public opacityStart(param: number | Resource | undefined) {
    this.getParam().startOpacity = param
    return this
  }

  /**
   * 终点透明度值参数
   * @param param
   * @returns
   */
  public opacityEnd(param: number | Resource | undefined) {
    this.getParam().endOpacity = param
    return this
  }

  private getParam(): INavSingleAnimationParam {
    return this._param
  }
}