/**
 * @author: HZWei
 * @date: 2025/1/2
 * @desc:  为了兼容在api11的使用
 */

/**
 * Defines the mode of stack operation.
 *
 * @enum { number }
 * @syscap SystemCapability.ArkUI.ArkUI.Full
 * @crossplatform
 * @atomicservice
 * @since 12
 */
export enum LaunchMode {
  /**
   * The default mode of stack operation.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  STANDARD = 0,
  /**
   * When the NavDestination with a specified name exists, it will be moved to top of stack,
   * otherwise, the behavior will be consistent with the STANDARD mode.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  MOVE_TO_TOP_SINGLETON = 1,
  /**
   * When the NavDestination with a specified name exists, the stack will pop until that NavDestination,
   * otherwise, the behavior will be consistent with the STANDARD mode.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  POP_TO_SINGLETON = 2,
  /**
   * Forced to create a new NavDestination instance.
   *
   * @syscap SystemCapability.ArkUI.ArkUI.Full
   * @crossplatform
   * @atomicservice
   * @since 12
   */
  NEW_INSTANCE = 3
}