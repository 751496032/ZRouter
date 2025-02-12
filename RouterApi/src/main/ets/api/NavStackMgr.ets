/**
 * @author: HZWei
 * @date: 2024/9/18
 * @desc:
 */
import { InterceptorMgr } from '../interceptions/InterceptorMgr';
import { DEFAULT_STACK_NAME, InterceptorInfo, RouteMetadata } from '../model/Model';
import LogUtil from '../utlis/LogUtil';
import { ObjectUtil } from '../utlis/ObjectUtil';
import { ArrayList, HashMap } from '@kit.ArkTS';
import NavStackState from '../model/NavStackState';
import { ZRouter } from './Router';
import { RouterInfo } from '../model/RouterInfo';

export default class NavStackMgr {
  private navStackMap: Map<string, NavPathStack> = new Map<string, NavPathStack>()
  private interceptorMgr = InterceptorMgr.getInstance()
  private navStackStateMap = new HashMap<string, NavStackState>()
  private _currentStackName = DEFAULT_STACK_NAME
  private onBeforeNavStackRegisterCallback?: Function
  private navDesMap = new HashMap<string, ArrayList<RouterInfo>>()

  private constructor() {
  }

  private static _instance: NavStackMgr;

  public static getInstance(): NavStackMgr {
    if (!NavStackMgr._instance) {
      NavStackMgr._instance = new NavStackMgr();
    }
    return NavStackMgr._instance;
  }

  public set currentStackName(name: string) {
    let has = false
    this.navStackStateMap.forEach((item) => {
      if (name === item?.stackName) {
        has = true
      }
    })
    if (!has) {
      if (ObjectUtil.isEmpty(name)) {
        throw new Error(`Initialize NavPathStack: 【 Navigation(ZRouter.getNavStack())  or  Navigation(ZRouter.getNavStackByName(xx))】`)
      }else {
        throw new Error(`stack name does not exist: 【 ${name} 】，please call  method  register: 【 registerNavStack 】`)
      }

    } else {
      this._currentStackName = name
    }
  }

  public get currentStackName(): string {
    if (this.navStackMap.has(this._currentStackName)) {
      return this._currentStackName
    }
    const keys = Array.from(this.navStackMap.keys())
    return keys[keys.length - 1]
  }


  public getNavStack(name: string = this.currentStackName, willShow?: InterceptionShowCallback): NavPathStack {
    return this.getNavStackByName(name, willShow)
  }

  public getNavStackByName(stackName: string, willShow?: InterceptionShowCallback): NavPathStack {
    let stack = this.navStackMap.get(stackName)
    if (stack !== undefined && stack !== null) {
      return stack as NavPathStack
    }
    stack = new NavPathStack()
    this.registerNavStack(stackName, stack, willShow)
    return stack
  }

  public getNavStackState(): NavStackState {
    let state = this.navStackStateMap.get(this._currentStackName)
    if (state !== undefined && state !== null) {
      return state as NavStackState
    }
    throw new Error(`current 【${this._currentStackName}】 state is null`)
  }

  public unregisterNavStack(stackName: string): void {
    this.navStackMap.delete(stackName)
  }

  public registerNavStack(stackName: string = DEFAULT_STACK_NAME, pathStack: NavPathStack,
    willShow?: InterceptionShowCallback): void {
    if (!this.navStackMap.has(stackName)) {
      this.navStackMap.set(stackName, pathStack)
      this.navStackStateMap.set(stackName, NavStackState.create(stackName))
      pathStack.setInterception({
        willShow: (from: NavDestinationContext | NavBar, to: NavDestinationContext | NavBar,
          operation: NavigationOperation, animated: boolean) => {
          const state = this.getNavStackState()
          LogUtil.log("from: ", this.getNavDestContext(from)?.pathInfo?.name , " isNavBar: " ,this.isNavBar(from),  " --> to: ", this.getNavDestContext(to)?.pathInfo?.name," isNavBar: " , this.isNavBar(to), ' operation: ', operation, "")

          if (willShow !== undefined) {
            willShow(from, to, operation, animated)
          }
          let isWillShowRootView = false
          let isWillShowNavDestView = false
          let fromContext: NavDestinationContext
          let toContext: NavDestinationContext
          const interceptorInfo = InterceptorInfo.create(false)
          const isPushOrReplace = operation === NavigationOperation.PUSH || operation === NavigationOperation.REPLACE
          if (isPushOrReplace) {
            try {
              const toContext: NavDestinationContext = to as NavDestinationContext
              interceptorInfo.toContext = toContext
              const data = toContext.getConfigInRouteMap()?.data
              if (ObjectUtil.isObject(data)) {
                const metadata: RouteMetadata = data as RouteMetadata
                metadata.name = toContext.getConfigInRouteMap()?.name
                interceptorInfo.name = metadata.name
                interceptorInfo.param = ZRouter.getInstance(state.stackName).getParam()
                interceptorInfo.metadata = metadata
              }

              state.stackTopInfo = interceptorInfo
            } catch (e) {
              // 检查route_map、装饰器Route、push三者的name值是否一致
              LogUtil.error((e as Error).message)
              LogUtil.error('push: 页面配置错误，请检查是否正确配置（检查route_map、装饰器Route、push三者的name值是否一致)')
            }
          } else {
            if (this.isNavBar(to)) {
              isWillShowRootView = true
              fromContext = from as NavDestinationContext
            }
          }
          if (ObjectUtil.isObject(from) && !isWillShowRootView) {
            fromContext = from as NavDestinationContext
            toContext = to as NavDestinationContext
            isWillShowNavDestView = true
          }else if (this.isNavBar(from) && !isWillShowRootView){
            toContext = to as NavDestinationContext
            fromContext = toContext
            isWillShowNavDestView = true
          }

          this.interceptorMgr.run(state.stackName, interceptorInfo, isPushOrReplace,
            (interceptor) => {
              if (isPushOrReplace) {
                interceptor.onNavigate?.(interceptorInfo)
              }
              if (isWillShowRootView) {
                interceptor.onRootWillShow?.(fromContext)
              }
              if (isWillShowNavDestView) {
                interceptor.onPageWillShow?.(fromContext, toContext)
              }
              interceptor.onShowCallback?.(from, to, operation, animated)
            })


        }
      })
    }
  }

  private isNavBar(context: NavDestinationContext | NavBar) {
    return context === 'navBar'
  }

  private getNavDestContext(context: NavDestinationContext | NavBar) {
    if (!this.isNavBar(context)) {
      return context as NavDestinationContext
    }
    return undefined
  }

  public addRouterInfo(routerInfo: RouterInfo) {
    let list = this.navDesMap.get(this._currentStackName)
    if (list) {
      list.add(routerInfo)
    } else {
      const list = new ArrayList<RouterInfo>()
      list.add(routerInfo)
      this.navDesMap.set(this._currentStackName, list)
    }
  }

  public removeRouterInfo(routerInfo: RouterInfo) {
    let list = this.navDesMap.get(this._currentStackName)
    if (list) {
      let pos = -1
      for (let i = 0; i < list.length; i++) {
        if (list[i].navDestinationId == routerInfo.navDestinationId) {
          pos = i
          break
        }
      }
      if (pos != -1) {
        list.removeByIndex(pos)
      }
    }
  }

  public getLastNavDestinationId(): string | undefined {
    let list = this.navDesMap.get(this._currentStackName)
    if (list && list.length > 0) {
      return list[list.length - 1].navDestinationId
    }
    return undefined
  }
}