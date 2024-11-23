import NavAnimateStatus from '../const/NavAnimateStatus'
import { NavAnimationModifier } from '../modifier/NavAnimationModifier'
import { AnimateCallback } from '../NavAnimationMgr'
import { INavAnimateOptions as INavAnimateSingleOptions } from './INavAnimateOptions'

/**
 * @author: HHBin
 * @date: 2024-11-14
 * @desc: 动画转场参数
 */
export interface INavSingleAnimationParam {
  // 转场动画函数参数
  animateParam?: AnimateParam
  // 起点回调
  startCallback?: (modifier: NavAnimationModifier, proxy: NavigationTransitionProxy | undefined) => void
  // 终点回调
  endCallback?: (modifier: NavAnimationModifier, proxy: NavigationTransitionProxy | undefined) => void
}

export class NavAnimateOptions {
  list: INavAnimateSingleOptions[] = []
  enterAnimateParam?: AnimateParam
  exitAnimateParam?: AnimateParam

  public setEnterAnimateParam(param: AnimateParam) {
    this.enterAnimateParam = param
    return this
  }

  public setExitAnimateParam(param: AnimateParam) {
    this.exitAnimateParam = param
    return this
  }

  public addOptions(options: INavAnimateSingleOptions) {
    this.list.push(options)
    return this
  }

  public update(callback: AnimateCallback): void {
    callback.pushEnterParam = {
      animateParam: this.enterAnimateParam,
      startCallback: (m) => this.updateList(m, true, NavAnimateStatus.PUSH_ENTER),
      endCallback: (m) => this.updateList(m, false, NavAnimateStatus.PUSH_ENTER),
    }
    callback.popExitParam = {
      animateParam: this.exitAnimateParam,
      startCallback: (m) => this.updateList(m, true, NavAnimateStatus.POP_EXIT),
      endCallback: (m) => this.updateList(m, false, NavAnimateStatus.POP_EXIT),
    }
    callback.pushExitParam = {
      animateParam: this.enterAnimateParam,
      startCallback: (m) => this.updateList(m, true, NavAnimateStatus.PUSH_EXIT),
      endCallback: (m) => this.updateList(m, false, NavAnimateStatus.PUSH_EXIT),
    }
    callback.popEnterParam = {
      animateParam: this.exitAnimateParam,
      startCallback: (m) => this.updateList(m, true, NavAnimateStatus.POP_ENTER),
      endCallback: (m) => this.updateList(m, false, NavAnimateStatus.POP_ENTER),
    }
  }

  private updateList(modifier: NavAnimationModifier, isStart: boolean, status: NavAnimateStatus): void {
    this.list.forEach((v) => {
      if (v) {
        v.updateModifier(modifier, isStart, status)
      }
    })
  }
}
