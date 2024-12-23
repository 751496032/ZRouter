/**
 * @author: HZWei
 * @date: 2024/7/15
 * @desc: NavDestination页面注解
 */

export function Route(param: Param) {
  return Object
}

/**
 * 可以替代@Route
 * @param param
 * @returns
 */
export function ZRoute(param: Param){
  return Object
}

interface Param {
  /**
   * 页面路由名称
   */
  name: string,
  /**
   * 是否使用NavDestination模板，true时，则页面组件可以不用NavDestination组件包裹，在编译阶段会自动生成NavDestination组件。
   * 可选，默认不使用
   */
  useTemplate?: boolean,
  /**
   * 页面标题，可选 在useTemplate为true时生效， 不支持常量设置
   * */
  title?: string

  /**
   * 是否使用v2状态管理，只针对NavDestination页面模板，默认不使用
   */
  useV2?: boolean

  /**
   * 是否隐藏标题栏，可选，只针对NavDestination页面模板
   */
  hideTitleBar?: boolean

  /**
   * 页面生命周期函数属性名称，可选，只针对NavDestination页面模板
   */
  loAttributeName  ?: string

  /**
   * 页面描述，可选
   */
  description?: string
  /**
   * 是否需要登录，可选
   */
  needLogin?: boolean
  extra?: string
}

