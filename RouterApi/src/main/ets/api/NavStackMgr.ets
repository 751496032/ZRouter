/**
 * @author: HZWei
 * @date: 2024/9/18
 * @desc:
 */
import { InterceptorMgr } from '../interceptions/InterceptorMgr';
import { DEFAULT_STACK_NAME, InterceptorInfo, ObjectOrNull, RouteMetadata } from '../model/Model';
import { ObjectUtil } from '../utlis/ObjectUtil';
import { ArrayList, HashMap } from '@kit.ArkTS';
import NavDestState from '../model/NavDestState';
import { ZRouter } from './Router';
import { RouterInfo } from '../model/RouterInfo';
import { RouterMgr } from './RouterMgr';
import Logger from '../utlis/Logger';
import { runCatching } from '../utlis/runCatching';
import { INavDestOptions } from '../model/NavDestOptions';

export default class NavStackMgr {
  private navStackMap: Map<string, NavPathStack> = new Map<string, NavPathStack>()
  private interceptorMgr = InterceptorMgr.getInstance()
  private navStateMap = new HashMap<string, NavDestState>()
  private _currentStackName: string | undefined = undefined
  private navDestMap = new HashMap<string, ArrayList<RouterInfo>>()

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
      if (ObjectUtil.isEmpty(name)) {
        throw new Error(`Initialize NavPathStack: 【 Navigation(ZRouter.getNavStack())  or  Navigation(ZRouter.getNavStackByName(xx))】`)
      } else {
        throw new Error(`stack name does not exist: 【 ${name} 】，please call  method  register: 【 registerNavStack 】`)
      }
    } else {
      this._currentStackName = name
    }
  }

  public get currentStackName(): string {
    if (ObjectUtil.isNotEmpty(this._currentStackName) ) {
      if (this.navStackMap.has(this._currentStackName!)) {
        const name = this._currentStackName!
        // this._currentStackName = undefined
        return name ?? DEFAULT_STACK_NAME
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

  public getNavDestState(): NavDestState {
    const name = this.currentStackName ?? DEFAULT_STACK_NAME
    let state = this.navStateMap.get(name)
    if (state) {
      return state as NavDestState
    } else {
      const r = runCatching(() => {
        return this.navStateMap.values().next().value as NavDestState
      }).getOrNull()
      if (r) {
        return r;
      }
    }
    throw new Error(`current 【${name}】 NavDestState is null`)
  }



  public unregisterNavStack(stackName: string): void {
    if (this.navStackMap.has(stackName)) {
      this.navStackMap.delete(stackName)
    }
    if (this.navStateMap.hasKey(stackName)) {
      this.navStateMap.remove(stackName)
    }

  }

  public registerNavStack(stackName: string = DEFAULT_STACK_NAME, pathStack: NavPathStack,
    willShow?: InterceptionShowCallback): void {
    if (!this.navStackMap.has(stackName)) {
      this.navStackMap.set(stackName, pathStack)
      this.navStateMap.set(stackName, NavDestState.create(stackName))
      pathStack.setInterception({
        willShow: (from: NavDestinationContext | NavBar, to: NavDestinationContext | NavBar,
          operation: NavigationOperation, animated: boolean) => {
          const state = this.getNavDestState()
          Logger.log(`setInterception ${state.stackName} from: `, this.getNavDestContext(from)?.pathInfo?.name , " isNavBar: " ,this.isNavBar(from),  " --> to: ", this.getNavDestContext(to)?.pathInfo?.name," isNavBar: " , this.isNavBar(to), ' operation: ', operation)

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
          const isPop = operation === NavigationOperation.POP
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
              interceptorInfo.navigationOptions = state.getDestOptions(toContext.pathInfo.name)
              state.stackTopInfo = interceptorInfo
            } catch (e) {
              // 检查route_map、装饰器Route、push三者的name值是否一致
              Logger.error((e as Error).message)
              Logger.error('push: 页面配置错误，请检查是否正确配置（检查route_map、装饰器Route、push三者的name值是否一致)')
            }
          } else {
            const routerMgr = RouterMgr.getInstance()
            if (this.isNavBar(to)) {
              isWillShowRootView = true
              fromContext = from as NavDestinationContext
            } else if (routerMgr.hideNavbar) {
              const names = routerMgr.getAllPathName()
              if (names.length === 1) {
                isWillShowRootView = true
                fromContext = from as NavDestinationContext
              }
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
                this.deleteAllDestBuildOpts()
              }
              if (isWillShowNavDestView) {
                interceptor.onPageWillShow?.(fromContext, toContext)
              }
              if (isPop) {
                interceptor.onPop?.(from as NavDestinationContext,
                  this.isNavBar(to) ? undefined : to as NavDestinationContext)
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
    if (ObjectUtil.isEmpty(name)) {
      return
    }
    let list = this.navDestMap.get(name)
    if (list) {
      list.add(routerInfo)
    } else {
      const list = new ArrayList<RouterInfo>()
      list.add(routerInfo)
      this.navDestMap.set(name, list)
    }
  }

  public deleteRouterInfo(routerInfo: RouterInfo) {
    let list = this.navDestMap.get(this.currentStackName)
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


  public deleteDestBuildOpts(name: string) {
    this.getNavDestState().deleteDestOptions(name)
  }

  public deleteAllDestBuildOpts() {
    runCatching(() => {
      this.navStateMap.forEach((value, key) => {
        value?.clearDestOptions()
      })
    })

  }

  public addDestBuildOpts(name: string, opts: INavDestOptions<ObjectOrNull>) {
    this.getNavDestState().setDestOptions(name, opts)
  }

  public getLastNavDestinationId(): string | undefined {
    let list = this.navDestMap.get(this.currentStackName)
    if (list && list.length > 0) {
      return list[list.length - 1].navDestinationId
    }
    return undefined
  }
}