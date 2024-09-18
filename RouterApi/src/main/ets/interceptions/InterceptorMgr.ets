/**
 * @author: HZWei
 * @date: 2024/9/16
 * @desc:
 */
import { IInterceptor, InterceptorTypes, ShowInterceptor } from './IInterceptor'
import { List } from '@kit.ArkTS'

export class InterceptorMgr {
  private interceptions = new Map<string, List<IInterceptor>>()
  private static  instance : InterceptorMgr

  public static getInstance(): InterceptorMgr {
    if (!InterceptorMgr.instance) {
      InterceptorMgr.instance = new InterceptorMgr()
      return InterceptorMgr.instance
    }
    return InterceptorMgr.instance
  }


  public addInterceptor(name: string, interceptor: IInterceptor) {
    if (this.interceptions.has(name)) {
      let  interceptors = this.interceptions.get(name)
      if (interceptors === undefined){
        interceptors = new List()
      }
      let has = false
      if (interceptor instanceof ShowInterceptor && interceptors.length > 0) {
         interceptors.forEach((item) => {
           if (item instanceof ShowInterceptor) {
             has = true
             return
           }
         })
      }
      if (!has) {
        interceptors.add(interceptor)
      }
    } else {
      const interceptors = new List<IInterceptor>()
      interceptors.add(interceptor)
      this.interceptions.set(name, interceptors)
    }
  }

  public removeInterceptor(name: string, interceptor: IInterceptor) {
    if (this.interceptions.has(name)) {
      const interceptors = this.interceptions.get(name)
      if (interceptors?.has(interceptor)) {
         interceptors.remove(interceptor)
      }
    } 
  }

  public run<T extends IInterceptor>(name: string, callback: (interceptor: T) => void) {
    if (this.interceptions.has(name)) {
      const interceptors = this.interceptions.get(name)
      if (interceptors == undefined) return
      interceptors.forEach((item)=>{
        if (item instanceof ShowInterceptor) {
          callback(item as T)
        }
      })
    }
  }

}
