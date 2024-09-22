/**
 * @author: HZWei
 * @date: 2024/9/16
 * @desc:
 */
import { IInterceptor, IGlobalNavigateInterceptor } from './IInterceptor'
import { List } from '@kit.ArkTS'
import { InterceptorInfo } from '../model/Model'

export class InterceptorMgr {
  private interceptions = new Map<string, List<IInterceptor>>()
  private static instance: InterceptorMgr
  private globalInterceptors = new  Map<string, IGlobalNavigateInterceptor>();

  public static getInstance(): InterceptorMgr {
    if (!InterceptorMgr.instance) {
      InterceptorMgr.instance = new InterceptorMgr()
      return InterceptorMgr.instance
    }
    return InterceptorMgr.instance
  }


  public addInterceptorToAllStack(interceptor: IInterceptor) {
    this.interceptions.forEach((value, key) => {
      this.addInterceptor(key, interceptor)
    })
  }


  public addInterceptor(stackName: string, interceptor: IInterceptor) {
    if (this.interceptions.has(stackName)) {
      let interceptors = this.interceptions.get(stackName)
      if (interceptors === undefined) {
        interceptors = new List()
      }
      if (!interceptors.has(interceptor)) {
        interceptors.add(interceptor)
      }
      interceptors.sort((a, b) => b.priority - a.priority); // 按优先级排序
    } else {
      const interceptors = new List<IInterceptor>()
      interceptors.add(interceptor)
      interceptors.sort((a, b) => b.priority - a.priority);
      this.interceptions.set(stackName, interceptors)
    }
  }

  public removeInterceptor(stackName: string, interceptor: IInterceptor) {
    if (this.interceptions.has(stackName)) {
      const interceptors = this.interceptions.get(stackName)
      if (interceptors?.has(interceptor)) {
        interceptors.remove(interceptor)
      }
    }
  }

  public setGlobalInterceptor(stackName: string, interceptor: IGlobalNavigateInterceptor) {
    if (!this.globalInterceptors.has(stackName)) {
      this.globalInterceptors.set(stackName, interceptor)
    }

  }

  public run(stackName: string, context: InterceptorInfo, isPush: boolean = false,
    callback?: (it: IGlobalNavigateInterceptor) => void): InterceptorInfo {
    if (this.interceptions.has(stackName) && isPush) {
      const interceptors = this.interceptions.get(stackName)
      if (interceptors) {
        for (let i = 0; i < interceptors.length; i++) {
          const item = interceptors.get(i)
          const newContext = item.process(context)
          if (newContext == undefined || newContext == null) {
            break
          } else {
            context = newContext
          }
        }
      }

    }

    if (this.globalInterceptors.has(stackName)) {
      let i = this.globalInterceptors.get(stackName)
      if (i) {
        callback && callback(i)
      }
    }

    return context
  }
}
