/**
 * @author: HZWei
 * @date: 2024/10/18
 * @desc: 服务路由注解
 */

export function Service(param: Param) {
  return Object
}

/**
 * 预留，后面会替代@Service
 * @param param
 * @returns
 */
export function ZService(param: Param){
  return Object
}

interface Param {
  name: String,

  /**
   * 预留字段
   */
  isDynamicInject?: boolean
}