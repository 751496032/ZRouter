/**
 * @author: HZWei
 * @date: 2024/9/22
 * @desc:
 */
import { IInterceptor, InterceptorInfo, InterceptorInfoOrNull, IGlobalNavigateInterceptor, ZRouter,
   } from 'routerapi';
import { promptAction } from '@kit.ArkUI';
import { HashMap } from '@kit.ArkTS';

export class GlobalNavigateInterceptor implements  IGlobalNavigateInterceptor{
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
  // 设置拦截器优先级，数值越大则优先执行
  priority: number = 10000;
  process: (context: InterceptorInfo) => InterceptorInfoOrNull = (context) => {
    console.log("IInterceptor process: ", this.priority , context.name)
    if (context.notRegistered) {
      if (this.isLink(context.name)) {
        const map = this.parseQueryString(context.name)
        const name = map.get('name')
        if (name) {
          ZRouter.getInstance()
            .setParam(map.get("id"))
            .navigation(name)
        }
      } else {
        ZRouter.getInstance().redirect("PageNotFound2")
      }
      return null // 返回null则拦截掉
    }
    return context
  };

   isLink(str: string): boolean {
    const linkRegex = /^(hzw:\/\/|http:\/\/|https:\/\/|www\.).+/;
    return linkRegex.test(str);
  }


  parseQueryString(queryString: string) {
    let params = new HashMap<string, string>();
    let queryStringWithoutQuestionMark = queryString.split('?')[1];
    if (queryStringWithoutQuestionMark) {
      let keyValues = queryStringWithoutQuestionMark.split('&');
      keyValues.forEach((keyValue) => {
        let pair = keyValue.split('=');
        let key = decodeURIComponent(pair[0]);
        let value = decodeURIComponent(pair[1]);
        params.set(key, value)
      })
    }
    return params;
  }

}