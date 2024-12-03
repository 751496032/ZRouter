/**
 * @author: HZWei
 * @date: 2024/7/15
 * @desc: NavDestination页面注解
 */

export function Route(param: Param) {
  return Object
}

/**
 * 预留，后面会替代@Route
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
   * 页面描述，可选
   */
  description?: string
  /**
   * 是否需要登录，可选
   */
  needLogin?: boolean
  extra?: string
}

