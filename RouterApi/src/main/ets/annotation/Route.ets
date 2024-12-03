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
  description?: string
  extra?: string
  needLogin?: boolean
}

