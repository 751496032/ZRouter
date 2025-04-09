/**
 * @author: HZWei
 * @date: 2024/11/7
 * @desc:  拦截器注册案例
 */

import { IInterceptor, InterceptorInfo, ZRouter } from "routerapi"
import { GlobalNavigateInterceptor, UrlInterceptor } from "./interceptors"

export function AddInterceptor(){

  // 可设置多个拦截器
  ZRouter.setInterceptor(new UrlInterceptor())
  // 全局拦截器
  ZRouter.setGlobalInterceptor(new GlobalNavigateInterceptor())

}