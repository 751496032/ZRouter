/**
 * @author: HZWei
 * @date: 2024/9/22
 * @desc:  拦截器案例
 */
import { IInterceptor, InterceptorInfo, InterceptorInfoOrNull, IGlobalNavigateInterceptor, ZRouter,
  RedirectType,
   } from 'routerapi';
import { promptAction } from '@kit.ArkUI';
import { HashMap } from '@kit.ArkTS';
import { RouterConstants, ToastUtils } from '@hzw/common_library';

export class GlobalNavigateInterceptor implements IGlobalNavigateInterceptor {
 static  count = 0
  onNavigateBefore: (context: InterceptorInfo) => Promise<InterceptorInfoOrNull> = (context) => {
    console.log("IInterceptor Global onNavigateBefore -> ", context.name)
    return new Promise((resolve, reject) => {
      if (context.name === RouterConstants.PAGE_BEFORE_PUSH) {
        // 拦截跳转到ParamPage页面
        if (GlobalNavigateInterceptor.count === 0) {
          context.param = ' 在拦截器onNavigateBefore中已替换参数 '
          GlobalNavigateInterceptor.count = 1
        }else if (GlobalNavigateInterceptor.count === 1){
          ToastUtils.show("拦截器onNavigateBefore中已拦截, 再点一次会继续执行")
          GlobalNavigateInterceptor.count = 2
          resolve(undefined)
        }
        resolve(context)
      } else {
        resolve(context)
      }

    })
  }

  onRootWillShow: ((fromContext: NavDestinationContext) => void) | undefined = (fromContext) => {
    console.log("IInterceptor Global onRootWillShow ->  from name: ", fromContext.pathInfo.name)
  }
  onPageWillShow: ((fromContext: NavDestinationContext, toContext: NavDestinationContext) => void) | undefined = (from ,to)=>{
    console.log("IInterceptor Global onPageWillShow -> ", " form name: ", from.pathInfo.name," to name: ", to.pathInfo.name)
  }

  onNavigate: ((context: InterceptorInfo) => void) | undefined = (info)=>{
    if (info.notRegistered) return
    console.log("IInterceptor Global onNavigate -> ", info.name)

    let isLogin = AppStorage.get<boolean>("isLogin")
    if (info.isNeedLogin && !isLogin) {
      let param = info.param
      // ZRouter.redirectForResult2<boolean>("LoginPage", param, (data) => {
      //   if (data.data) {
      //     // 登录成功
      //     promptAction.showToast({ message: `登录成功` })
      //     return true // 返回true 则继续跳转登录前的页面
      //   }
      //   return false
      // })

      ZRouter.getInstance()
        .setParam(param)
        .setAnimate(true)
        .setPopListener((result) => {
          if (result.data) {
            //  登录成功
            promptAction.showToast({ message: `登录成功` })
            return true // 返回true 则继续跳转登录前的页面
          } else {
            return false
          }
        })
        .redirect("LoginPage", RedirectType.REPLACE)

    }

  }
}

export class UrlInterceptor implements IInterceptor {
  // 设置拦截器优先级，数值越大则优先执行
  priority: number = 10000;
  process: (context: InterceptorInfo) => InterceptorInfoOrNull = (context) => {
    // console.log("IInterceptor process: ", this.priority , context.name)
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

export class TestInterceptor implements IInterceptor {
  process: (context: InterceptorInfo) => InterceptorInfoOrNull =(context)=>{
    console.log("IInterceptor TestInterceptor: ", context.name)
    return context
  }

  priority: number = 100;

}