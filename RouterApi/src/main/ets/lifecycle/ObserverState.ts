/**
 * @author: HZWei
 * @date: 2024/10/27
 * @desc:
 */

export class ObserverState {
  /**
   * 页面的类名 XXX__hash
   */
  className?: string
  /**
   * NavDestination的id
   */
  navDestinationId?: string;
  /**
   * 是否已经调用过aboutToAppear
   */
  isAboutToAppearCalled: boolean = false;

  /**
   * 是否允许调用aboutToDisappear，在onDisAppear中会设置为true
   */
  isAboutToDisappearAllowed: boolean = false;

  /**
   * 是否是根页面
   */
  isRootView: boolean = false;
}
export const SPLIT_SYMBOL: string = "__"