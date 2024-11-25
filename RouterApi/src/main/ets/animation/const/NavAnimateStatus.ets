/**
 * @author: HHBin
 * @date: 2024-11-23
 * @desc: 路由动画状态
 */
export default class NavAnimateStatus {
  // 进入状态(PUSH) 进入页的动画转场（A进入B 的 B进入转场）
  static readonly  PUSH_ENTER = 1
  // 进入状态(PUSH) 离开页的动画转场（A进入B 的 A离开转场）
  static readonly  PUSH_EXIT = 2
  // 退出状态(POP) 进入页的动画转场（B返回A 的 A进入转场）
  static readonly  POP_ENTER = 3
  // 退出状态(POP) 离开页的动画转场（B返回A 的 B离开转场）
  static readonly  POP_EXIT = 4
}