/**
 * @author: HZWei
 * @date: 2024/9/18
 * @desc:
 */
import { InterceptorMgr } from '../interceptions/InterceptorMgr';
import { DEFAULT_STACK_NAME, InterceptorInfo, RouteMetadata } from '../model/Model';
import LogUtil from '../utlis/LogUtil';
import { ObjectUtil } from '../utlis/ObjectUtil';
import { HashMap } from '@kit.ArkTS';
import NavStackState from '../model/NavStackState';
import { ZRouter } from './Router';

export default class NavStackMgr {
    private navStackMap: Map<string, NavPathStack> = new Map<string, NavPathStack>()
    private interceptorMgr = InterceptorMgr.getInstance()
    private navStackStateMap = new HashMap<string, NavStackState>()
    private _currentStackName = DEFAULT_STACK_NAME
    private constructor() {
    }

    private static _instance: NavStackMgr;
    public static  getInstance(): NavStackMgr {
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
            throw new Error(`stack name does not exist: 【 ${name} 】`)
        } else {
            this._currentStackName = name
        }
    }

    public get currentStackName(): string {
        return this._currentStackName
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

    public registerNavStack(stackName: string = DEFAULT_STACK_NAME, pathStack: NavPathStack, willShow?: InterceptionShowCallback): void {
        if (!this.navStackMap.has(stackName) ) {
            this.navStackMap.set(stackName, pathStack)
            this.navStackStateMap.set(stackName, NavStackState.create(stackName))
            pathStack.setInterception({
                willShow: (from: NavDestinationContext | NavBar, to: NavDestinationContext | NavBar,
                    operation: NavigationOperation, animated: boolean) => {
                    const state = this.getNavStackState()
                    LogUtil.log('operation: ', operation)
                    if (willShow !== undefined) {
                        willShow(from, to, operation, animated)
                    }
                    let isShowRoot = false
                    let isShowPage = false
                    let fromContext: NavDestinationContext
                    let toContext: NavDestinationContext
                    const interceptorInfo = InterceptorInfo.create(false)
                    if (operation === NavigationOperation.PUSH) {
                        try {
                            const toContext: NavDestinationContext = to as NavDestinationContext
                            interceptorInfo.toContext = toContext
                            const data = toContext.getConfigInRouteMap()?.data
                            if (ObjectUtil.isObject(data)) {
                                const metadata: RouteMetadata = data as RouteMetadata
                                metadata.name = toContext.getConfigInRouteMap()?.name
                                interceptorInfo.name = metadata.name
                                interceptorInfo.param = ZRouter.getParam()
                                interceptorInfo.metadata = metadata
                            }

                            state.stackTopInfo = interceptorInfo
                        } catch (e) {
                            // 检查route_map、装饰器Route、push三者的name值是否一致
                            LogUtil.error((e as Error).message)
                            LogUtil.error('push: 页面配置错误，请检查是否正确配置（检查route_map、装饰器Route、push三者的name值是否一致)')
                        }
                    } else {
                        if (to === 'navBar') {
                            isShowRoot = true
                            fromContext = from as NavDestinationContext
                        }
                    }
                    if (ObjectUtil.isObject(from) && !isShowRoot) {
                        fromContext = from as NavDestinationContext
                        toContext = to as NavDestinationContext
                        isShowPage = true
                    }

                    this.interceptorMgr.run(state.stackName, interceptorInfo, operation == NavigationOperation.PUSH,
                        (interceptor) => {
                        if (operation == NavigationOperation.PUSH) {
                            interceptor.onNavigate?.(interceptorInfo)
                        }
                        if (isShowRoot) {
                            interceptor.onRootWillShow?.(fromContext)
                        }
                        if (isShowPage) {
                            interceptor.onPageWillShow?.(fromContext, toContext)
                        }
                        interceptor.onShowCallback?.(from, to, operation, animated)
                    })



                }
            })
        }
    }





}