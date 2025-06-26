/**
 * @author: HZWei
 * @date: 2024/9/22
 * @desc: 拦截器案例
 */
import {
  IInterceptor,
  InterceptorInfo,
  InterceptorInfoOrNull,
  IGlobalNavigateInterceptor,
  ZRouter,
  RedirectType,
  DestinationInfo,
  NavigationAction,
} from 'routerapi';
import { promptAction } from '@kit.ArkUI';
import { HashMap } from '@kit.ArkTS';
import { RouterConstants, ToastUtils } from '@hzw/common_library';

function wait(ms: number): Promise<void> {
  return new Promise((resolve, _) => {
    setTimeout(() => {
      resolve()
    }, ms)
  })
}

class GlobalNavigateInterceptor implements IGlobalNavigateInterceptor {
  count = 0
  onRootShow?: () => void
  onNavigateBefore: (destInfo: DestinationInfo) => Promise<DestinationInfo> = (destInfo) => {
    console.log("IInterceptor Global onNavigateBefore -> ", destInfo.name)
    return new Promise( async (resolve, _) => {
      if (destInfo.name === RouterConstants.PAGE_BEFORE_PUSH) {
        // 拦截跳转到ParamPage页面
        if (this.count === 0) {
          destInfo.param = ' 在拦截器onNavigateBefore中已替换参数 '
          destInfo.next() // 继续跳转 默认的 ，可以不写
        } else if (this.count === 1) {
          ToastUtils.show("拦截器onNavigateBefore中已拦截, 再点一次会继续执行")
          destInfo.block() // 拦截跳转
        } else if (this.count === 2) {
          await wait(2000)
          destInfo.name = RouterConstants.LIFECYCLE_CASE_VIEW
        }
        this.count += 1
        resolve(destInfo)
      } else {
        resolve(destInfo)
      }

    })
  }

  onRootWillShow: ((fromContext: NavDestinationContext) => void)  = (fromContext) => {
    console.log("IInterceptor Global onRootWillShow ->  from name: ", fromContext.pathInfo.name)
    this.onRootShow?.()
  }
  onPageWillShow: ((fromContext: NavDestinationContext, toContext: NavDestinationContext) => void) | undefined =
    (from, to) => {
      console.log("IInterceptor Global onPageWillShow -> ", " form name: ", from.pathInfo.name, " to name: ",
        to.pathInfo.name)
    }
  onNavigate: ((context: InterceptorInfo) => void)  = (info) => {
    if (info.notRegistered) {
      return
    }
    console.log("IInterceptor Global onNavigate -> ", info.name)

    let isLogin = AppStorage.get<boolean>("isLogin")
    if (info.isNeedLogin && !isLogin) {
      let param = info.param
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
        .redirect(RouterConstants.LOGIN_PAGE, RedirectType.REPLACE)

    }
  }
  onPop?: ((fromContext: NavDestinationContext, toContext: NavDestinationContext | undefined) => void) = (from, to) => {
    console.log("IInterceptor Global onPop -> ", " form name: ", from.pathInfo.name, " to name: ",
      to?.pathInfo.name)
  }
}


/**
 * @deprecated
 */
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
  process: (context: InterceptorInfo) => InterceptorInfoOrNull = (context) => {
    console.log("IInterceptor TestInterceptor: ", context.name)
    return context
  }
  priority: number = 100;
}

const globalInterceptor = new GlobalNavigateInterceptor()

export { globalInterceptor as GlobalNavInterceptorMgr }