/**
 * @author: HZWei
 * @date: 2024/7/15
 * @desc: NavDestination页面注解
 */

export function Route(param: Param) {
  console.log("hook route: ",JSON.stringify(param))
  return Object
}

interface Param {
  name: string,
  description?: string
  extra?: string
  needLogin?: boolean
}

