/**
 * @author: HZWei
 * @date: 2024/10/23
 * @desc: 生命周期抽象接口
 */

export interface ILifeCycle {}

export interface IPageLifeCycle extends ILifeCycle {

  aboutToAppear?(): void


  /**
   * 页面每次显示时触发一次，包括路由过程、应用进入前台等场景，仅@Entry装饰的自定义组件生效。
   */
  onPageShow?(): void
  /**
   * 页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景，仅@Entry装饰的自定义组件生效。
   */
  onPageHide?(): void

  /**
   * 当用户点击返回按钮时触发，仅@Entry装饰的自定义组件生效
   * @returns 返回true表示页面自己处理返回逻辑，不进行页面路由；返回false表示使用默认的路由返回逻辑，不设置返回值按照false处理。
   */
  // onBackPress?(): void | boolean

  aboutToDisappear? (): void

}

export interface INavLifeCycle extends ILifeCycle {
  /**
   * 当该NavDestination页面显示时触发此回调
   */
  onShown?(): void

  /**
   * 当该NavDestination页面隐藏时触发此回调
   */
  onHidden?(): void

/**
 * 当该NavDestination挂载之前触发此回调
 */
  onWillAppear?(): void

  /**
   * 当该Destination显示之前触发此回调
   */
  onWillShow?(): void

  /**
   * 当该Destination隐藏之前触发此回调
   */
  onWillHide?(): void

  /**
   * 当该Destination卸载之前触发的生命周期(有转场动画时，在转场动画开始之前触发)
   */
  onWillDisappear?():void

  /**
   * NavDestination在组件树上挂载时触发此回调
   */
  onAppear?(): void

  /**
   * NavDestination从组件树上卸载时触发此回调
   */
  onDisappear?(): void

  /**
   * NavDestination组件返回时触发此回调
   */
  // onBackPress?: () => void

  /**
   * 当NavDestination即将构建子组件之前会触发此回调。
   */
  // onReady?(): void


}