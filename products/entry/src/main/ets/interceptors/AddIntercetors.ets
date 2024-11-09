/**
 * @author: HZWei
 * @date: 2024/11/7
 * @desc:  拦截器注册案例
 */

import { IInterceptor, InterceptorInfo, ZRouter } from "routerapi"
import { GlobalNavigateInterceptor, UrlInterceptor } from "./interceptors"

export function AddInterceptor(){

  // 第一种方式设置拦截器，字面量对象的形式
  ZRouter.setInterceptor({
    priority: 100,
    process: (info: InterceptorInfo) => {
      console.log("IInterceptor process: ", 100, info.name)
      return info
    }
  } as IInterceptor)
  // 第二种方式设置拦截器，类的形式
  ZRouter.setInterceptor(new UrlInterceptor()) // 可设置多个拦截器
  ZRouter.setGlobalInterceptor(new GlobalNavigateInterceptor()) // 全局拦截器



  // ZRouter.addGlobalInterceptor((info) => {
  //   // LogUtil.log('GlobalInterceptor: ', JSON.stringify(info.metadata) , info.isNeedLogin)
  //   if (info.notRegistered) {
  //     // 页面不存在，重定向到提示页 PageNotFound
  //     ZRouter.redirect("PageNotFound2")
  //     return
  //   }
  //   let isLogin = AppStorage.get<boolean>("isLogin")
  //   if (info.isNeedLogin && !isLogin) {
  //     let param = ZRouter.getParamByName(info.metadata?.name ?? "")
  //     ZRouter.redirectForResult2<boolean>("LoginPage", param, (data) => {
  //         if (data.data) {
  //           // 登录成功
  //           promptAction.showToast({ message: `登录成功` })
  //           return true // 返回true 则继续跳转登录前的页面
  //         }
  //         return false
  //       })
  //   }
  // })
}