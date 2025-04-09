/**
 * @author: HZWei
 * @date: 2024/9/18
 * @desc:
 */
import { InterceptorMgr } from '../interceptions/InterceptorMgr';
import { DEFAULT_STACK_NAME, InterceptorInfo, RouteMetadata } from '../model/Model';
import LogUtil from '../utlis/LogUtil';
import { ObjUtil } from '../utlis/ObjUtil';
import { ArrayList, HashMap } from '@kit.ArkTS';
import NavStackState from '../model/NavStackState';
import { ZRouter } from './Router';
import { RouterInfo } from '../model/RouterInfo';

export default class NavStackMgr {
  private navStackMap: Map<string, NavPathStack> = new Map<string, NavPathStack>()
  private interceptorMgr = InterceptorMgr.getInstance()
  private navStackStateMap = new HashMap<string, NavStackState>()
  private _currentStackName: string | undefined = undefined
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

  public updateCurrentStackName(name: string) {
    if (!this.navStackMap.has(name)) {
      if (ObjUtil.isEmpty(name)) {
        throw new Error(`Initialize NavPathStack: 【 Navigation(ZRouter.getNavStack())  or  Navigation(ZRouter.getNavStackByName(xx))】`)
      } else {
        throw new Error(`stack name does not exist: 【 ${name} 】，please call  method  register: 【 registerNavStack 】`)
      }
    } else {
      this._currentStackName = name
    }
  }

  public get currentStackName(): string {
    if (ObjUtil.isNotEmpty(this._currentStackName) ) {
      if (this.navStackMap.has(this._currentStackName!)) {
        const name = this._currentStackName!
        // this._currentStackName = undefined
        return name
      } else {
        throw new Error(`stack name does not exist: 【 ${this._currentStackName} 】，please call  method  register: 【 registerNavStack 】`)
      }

    }
    // this.tryRemoveInvalidNavStack()
    const newKeys = Array.from(this.navStackMap.keys())
    return newKeys[newKeys.length - 1]
  }

  public tryRemoveInvalidNavStack() {
    if (this.navStackMap.size > 1) {
        this.navStackMap.forEach((item, key) => {
          if (item.size() === 0 && key !== DEFAULT_STACK_NAME) {
            this.unregisterNavStack(key)
          }
        })
    }
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
    const name = this.currentStackName
    let state = this.navStackStateMap.get(name)
    if (state !== undefined && state !== null) {
      return state as NavStackState
    }
    throw new Error(`current 【${name}】 state is null`)
  }

  public unregisterNavStack(stackName: string): void {
    if (this.navStackMap.has(stackName)) {
      this.navStackMap.delete(stackName)
    }
    if (this.navStackStateMap.hasKey(stackName)) {
      this.navStackStateMap.remove(stackName)
    }

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
          LogUtil.log(`setInterception ${state.stackName} from: `, this.getNavDestContext(from)?.pathInfo?.name , " isNavBar: " ,this.isNavBar(from),  " --> to: ", this.getNavDestContext(to)?.pathInfo?.name," isNavBar: " , this.isNavBar(to), ' operation: ', operation)

          if (willShow !== undefined) {
            willShow(from, to, operation, animated)
          }
          let isWillShowRootView = false
          let isWillShowNavDestView = false
          let fromContext: NavDestinationContext
          let toContext: NavDestinationContext
          const interceptorInfo = InterceptorInfo.create(false)
          interceptorInfo.operation = operation
          const isPushOrReplace = operation === NavigationOperation.PUSH || operation === NavigationOperation.REPLACE
          if (isPushOrReplace) {
            try {
              const toContext: NavDestinationContext = to as NavDestinationContext
              interceptorInfo.toContext = toContext
              const data = toContext.getConfigInRouteMap()?.data
              if (ObjUtil.isObject(data)) {
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
          if (ObjUtil.isObject(from) && !isWillShowRootView) {
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
    const name = this.currentStackName
    let list = this.navDesMap.get(name)
    if (list) {
      list.add(routerInfo)
    } else {
      const list = new ArrayList<RouterInfo>()
      list.add(routerInfo)
      this.navDesMap.set(name, list)
    }
  }

  public removeRouterInfo(routerInfo: RouterInfo) {
    let list = this.navDesMap.get(this.currentStackName)
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
    let list = this.navDesMap.get(this.currentStackName)
    if (list && list.length > 0) {
      return list[list.length - 1].navDestinationId
    }
    return undefined
  }
}