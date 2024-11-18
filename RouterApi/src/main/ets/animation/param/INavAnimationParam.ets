/**
 * @author: HHBin
 * @date: 2024-11-14
 * @desc: 动画转场参数
 */
export interface INavAnimationParam {
  // 进入状态(PUSH) 进入页的动画转场参数（A进入B 的 B进入转场）
  pushEnterParam?: INavSingleAnimationParam
  // 进入状态(PUSH) 离开页的动画转场参数（A进入B 的 A离开转场）
  pushExitParam?: INavSingleAnimationParam
  // 退出状态(POP) 进入页的动画转场参数（B返回A 的 A进入转场）
  popEnterParam?: INavSingleAnimationParam
  // 退出状态(POP) 离开页的动画转场参数（B返回A 的 B离开转场）
  popExitParam?: INavSingleAnimationParam
}
export interface INavSingleAnimationParam {
  // 转场动画函数参数
  animateParam?: AnimateParam
  // 起点平移果参数
  startTranslateOptions?: TranslateOptions
  // 终点平移参数
  endTranslateOptions?: TranslateOptions
  // 起点缩放参数
  startScaleOptions?: ScaleOptions
  // 终点缩放参数
  endScaleOptions?: ScaleOptions
  // 起点旋转参数
  startRotateOptions?: RotateOptions
  // 终点旋转参数
  endRotateOptions?: RotateOptions
  // 起点透明度值参数
  startOpacity?: number | Resource
  // 终点透明度值参数
  endOpacity?: number | Resource
}