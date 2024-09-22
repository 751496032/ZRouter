/**
 * @author: HZWei
 * @date: 2024/9/22
 * @desc:
 */
import { IInterceptor, InterceptorInfo, InterceptorInfoOrNull, IPageNavigateInterceptor, ZRouter,
   } from 'routerapi';
import { promptAction } from '@kit.ArkUI';

export class CustomPageNavigateInterceptor implements  IPageNavigateInterceptor{
  onRootWillShow?: ((fromContext: NavDestinationContext) => void) | undefined = (fromContext) => {
    console.log("IInterceptor Global onRootWillShow: ", fromContext.pathInfo.name)
  }
  onPageWillShow?: ((fromContext: NavDestinationContext, toContext: NavDestinationContext) => void) | undefined = (from ,to)=>{
    console.log("IInterceptor Global onPageWillShow: ", from, to.pathInfo.name, to.pathInfo.param)
  }

  onNavigate?: ((context: InterceptorInfo) => void) | undefined = (info)=>{
    if (info.notRegistered) return
    console.log("IInterceptor Global onNavigate: ", info.name)

    let isLogin = AppStorage.get<boolean>("isLogin")
    if (info.isNeedLogin && !isLogin) {
      let param = info.param
      ZRouter.redirectForResult2<boolean>("LoginPage", param, (data) => {
        if (data.data) {
          // 登录成功
          promptAction.showToast({ message: `登录成功` })
          return true // 返回true 则继续跳转登录前的页面
        }
        return false
      })
    }

  }
}

export class UrlInterceptor implements IInterceptor {

  // 设置优先级，数值越大则优先执行
  priority: number = 10000;

  process: (context: InterceptorInfo) => InterceptorInfoOrNull = (context) => {
    console.log("IInterceptor process: ", this.priority , context.name)
    if (context.notRegistered) {
      ZRouter.getInstance().redirect("PageNotFound2")
       return null // 返回null则拦截掉
    }
    return context
  };

}