
/**
 * @author: HZWei
 * @date: 2024/10/27
 * @desc:
 */

import { RouterInfo } from "../model/RouterInfo";


export enum LifecycleEvent {
  ON_SHOWN = "onShown",
  ON_HIDDEN = "onHidden",
  ON_APPEAR = "onAppear",
  ON_DISAPPEAR = "onDisappear",
  ON_WILL_SHOW = "onWillShow",
  ON_WILL_HIDE = "onWillHide",
  ON_WILL_APPEAR = "onWillAppear",
  ON_WILL_DISAPPEAR = "onWillDisappear",
  /**
   * @deprecated
   */
  ON_BACK_PRESS = "onBackPress",
  ABOUT_TO_APPEAR = "aboutToAppear",
  ON_PAGE_SHOW = "onPageShow",
  ON_PAGE_HIDE = "onPageHide",
  ABOUT_TO_DISAPPEAR = "aboutToDisappear",
}

/**
 * 用于模板化的生命周期状态
 */
export enum LifecycleState {
  ON_WILL_SHOW = "onWillShow",
  ON_SHOWN = "onShown",
  ON_WILL_HIDE = "onWillHide",
  ON_HIDDEN = "onHidden",
  ON_DISAPPEAR = "onDisappear",
  ON_WILL_DISAPPEAR = "onWillDisappear",
  ON_BACK_PRESS = "onBackPress",
}

export type LifecycleCallback = (event: LifecycleEvent, router?: RouterInfo) => void;

export type LifecycleObserver = (event: LifecycleState, router?: RouterInfo) => void | boolean;