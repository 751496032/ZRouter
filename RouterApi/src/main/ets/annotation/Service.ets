/**
 * @author: HZWei
 * @date: 2024/10/18
 * @desc: 服务路由注解
 */

export function Service(param: ServiceParam) {
  return Object
}

export interface ServiceParam {
  name: String,
  /**
   * 预留字段
   */
  isDynamicInject?: boolean
}