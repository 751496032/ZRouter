/**
 * @author: HZWei
 * @date: 2024/9/11
 * @desc:
 */
import { RouterMgr } from '../api/RouterMgr';
import { ObjectOrNull, OnPopResultCallback, PopResult, RouteMetadata } from './Model';
import { INavDestOptions, NavDestOptionsImpl } from './NavDestOptions';
import { NavAnimationMgr } from '../animation/NavAnimationMgr';
import { ArrayList, HashMap } from '@kit.ArkTS';
import { ObjUtil } from '../utlis/ObjUtil';
import { RedirectType } from './Const';
import { LaunchMode } from './LaunchMode';
import Logger from '../utlis/Logger';
import { ZRouter } from '../api/Router';

export class NavDestBuilder<T> {
  private optionsImpl: INavDestOptions<T> = new NavDestOptionsImpl<T>();
  private routerMgr: RouterMgr
  private paramMap = new HashMap<string, ObjectOrNull>()

  get options(): INavDestOptions<T> {
    return this.optionsImpl
  }

  public static  create<T>(routerMgr: RouterMgr, stackName: string): NavDestBuilder<T> {
    return new NavDestBuilder<T>(routerMgr, stackName)
  }

  private constructor(routerMgr: RouterMgr, stackName: string) {
    this.routerMgr = routerMgr
    this.optionsImpl.navStackName = stackName
  }

  /**
   * 是否启动动画
   * @param animated
   * @returns
   */
  public setAnimate(animated: boolean): NavDestBuilder<T> {
    this.optionsImpl.animated = animated;
    return this;
  }

  /**
   * 设置启动模式，api12起才会生效
   * @param mode
   * @returns
   */
  public setLunchMode(mode: LaunchMode): NavDestBuilder<T> {
    this.optionsImpl.lunchMode = mode;
    return this;
  }

  /**
   * 页面跳转携带的参数
   * setParam 和 withParam 方法的区别是，setParam 方法会覆盖之前的参数，而 withParam 方法会合并之前的参数，但不会合并setParam基本类型的参数
   * @param param
   * @returns
   */
  public setParam(param: ObjectOrNull): NavDestBuilder<T> {
    // enableConvertJumpParamZeroAndFalseToString()方法启用
    if (this.optionsImpl.isConvertJumpParamZeroAndFalseToString) {
      if (typeof param === 'number' && param === 0) {
        param = '0'
      } else if (typeof param === 'boolean' && !param) {
        param = 'false'
      }
    }
    this.optionsImpl.params = param;
    return this;
  }

  /**
   * 页面跳转携带的参数，键值对的方式
   * @param key
   * @param value
   * @returns
   */
  public withParam(key: string, value: ObjectOrNull): NavDestBuilder<T> {
    this.paramMap.set(key, value)
    return this
  }

  /**
   * 页面跳转携带的参数，map的方式
   * @param key
   * @param value
   * @returns
   */
  public withParams(paramMap: HashMap<string, ObjectOrNull>): NavDestBuilder<T> {
    this.paramMap = paramMap
    return this
  }

  /**
   * 监听返回携带的结果
   * @param callback
   * @returns
   */
  public setPopListener(callback: OnPopResultCallback<T | ObjectOrNull>): NavDestBuilder<T> {
    this.optionsImpl.onPopListener = callback;
    return this;
  }

  /**
   * 开启跨多级页面回调监听，这种场景返回需要使用popNavWithResult()方法， popNavWithResult()已废弃
   * @date 2025/4/19 如果在Navigation根视图中push需要监听返回数据，则需要设置listenPopResultOnRootView为true
   * @deprecated
   * @see listenPopResultOnRootView替代
   * @returns
   */
  public enableCrossPageParamReturn(): NavDestBuilder<T> {
    this.optionsImpl.listenPopResultOnRootView = true;
    return this;
  }

  /**
   * 如果在Navigation根视图中push需要监听返回数据，则需要设置listenPopResultOnRootView为true
   * 如果开启了，需要与popToRootWithResult()方法搭配使用
   * @returns
   */
  public listenPopResultOnRootView(): NavDestBuilder<T> {
    this.optionsImpl.listenPopResultOnRootView = true;
    return this;
  }

  /**
   * 开启将0 和 false 转成字符串，Navigation跳转携带参数时，系统不支持直接携带0 和 false， 如果需要携带只能转成字符串
   * 这种场景由开发者决定是否需要启用，默认不启用
   * 在setParam()方法中控制，必须在setParam()方法之前调用
   * @returns
   * @deprecated
   */
  public enableConvertJumpParamZeroAndFalseToString(): NavDestBuilder<T> {
    this.optionsImpl.isConvertJumpParamZeroAndFalseToString = true;
    return this;
  }

  private updateCurrentStackName(): void {
    this.routerMgr.setCurrentStackName(this.optionsImpl.navStackName)
  }

  private mergeParams(): ObjectOrNull {
    let param = this.optionsImpl.params
    if (this.paramMap.length === 0) {
      return param
    }
    const objs = new Array<object>()
    if (!(param instanceof Array) && !(param instanceof Set) && ObjUtil.isObject(param)) {
      objs.push(param!)
    }
    if (this.paramMap.length > 0 ) {
      let newObj: Record<string, ObjectOrNull> = {};
      this.paramMap.forEach((val, key) => {
        if (key) {
          newObj[key] = val
        }
      })
      objs.push(newObj)
    }

    if (param && !ObjUtil.isObject(param) && objs.length > 0) {
      throw new Error('当setParam()和withParam()方法同时调用时，setParam()方法的实参不能为基本数据类型，必须是对象')
    }


    if (objs.length > 0 || ObjUtil.isEmpty(param)) {
      param = ObjUtil.merge(objs)
    }


    return param
  }


  /**
   * 页面跳转
   * @param name 页面路由名称
   */
  public navigation(name: string): void {
    this.updateCurrentStackName()
    if (this.optionsImpl.onPopListener) {
      if (this.optionsImpl.listenPopResultOnRootView) {
        this.routerMgr.pushNavForResult<T>(name, this.mergeParams(), this.optionsImpl.onPopListener,this)
      } else {
        this.routerMgr.pushForResult(name, this.mergeParams(), (data) => {
          let result = data.result
          let from = data.info.name
          let r = new PopResult<ObjectOrNull>()
          r.data = result
          r.from = from
          this.optionsImpl.onPopListener?.(r as PopResult<T>)
        }, this)
      }

    } else {
      this.routerMgr.push(name, this.mergeParams(), this.optionsImpl.animated, this)
    }
  }

  /**
   * 页面跳转
   * @param name 页面路由名称
   */
  public push(name: string) {
    this.navigation(name)
  }

  /**
   * 将当前NavDestination替换为特定NavDestination。当前的NavDestination将被销毁。
   * @param name
   */
  public replace(name: string) {
    this.updateCurrentStackName()
    this.routerMgr.replacePathByName(name, this.mergeParams(), this.optionsImpl.animated, this)
  }

  /**
   * 将当前NavDestination替换为特定NavDestination。当前的NavDestination将被销毁。默认转场动画
   * 解决replace()方法无动画问题
   * @param name
   */
  public replaceWithDefaultAnim(name: string) {
    const beforePath = this.getTopPathName() ?? ""
    this.navigation(name)
    setTimeout(() => {
      this.routerMgr.removeByName(beforePath)
    }, 500)
  }

  /**
   * 重定位页面，建议在拦截器中使用，与finishWithResult()方法搭配使用
   * 比如用于拦截未登录的场景，当未登录时，在拦截器中重定向到登录页，当登录成功后，通过finishWithResult()方法关闭当前页，
   * 在onPopListener的回调函数中返回true则会继续跳转到未登录前的页面。
   * 注意：如果登录流程中间有多个页面，需要在finishWithResult()方法前手动调用pop()方法关闭。
   * @param name
   */
  public redirect(name: string, type: RedirectType = RedirectType.REPLACE) {
    this.updateCurrentStackName()
    this.optionsImpl.redirectType = type
    if (this.optionsImpl.onPopListener) {
      this.routerMgr.redirectForResult2<T>(name, this.mergeParams(), this.optionsImpl.onPopListener, this)
    } else {
      this.routerMgr.redirect(name, this)
    }
  }

  /**
   * 返回上一页
   * @param animated
   */
  public pop(animated: boolean = true): boolean {
    this.updateCurrentStackName()
    return this.routerMgr.pop(animated)
  }


  /**
   * 返回指定路由名称的页面，会关闭中间页面
   * @param name 路由名称
   * @param animated 是否执行动画
   * @returns number  页面在栈中的索引index
   */
  public popToName(name: string, animated: boolean = true): number {
    this.updateCurrentStackName()
    return this.routerMgr.popToName(name, animated)
  }


  /**
   * 携带结果返回指定路由名称的页面，会关闭中间页面，可以替代popNavWithResult
   * 可在onPopListener回调函数内监听
   * @param name
   * @param result
   * @param animated
   * @returns
   */
  public popToNameWithResult<T>(name: string, result: T, animated: boolean = true): number {
    this.updateCurrentStackName()
    return this.routerMgr.popToNameWithResult<T>(name, result, animated)
  }

  /**
   * 携带结果返回上一页，可在onPopListener回调函数内监听
   * @param result 返回携带的数据
   * @param animated 是否执行动画
   * @returns boolean 是否返回成功
   */
  public popWithResult(result: Object , animated: boolean = true): boolean {
    this.updateCurrentStackName()
    return this.routerMgr.popWithResult(result, animated)
  }

  /**
   * 携带结果返回到指定的页面(可以跨多级页面)，可在onPopListener回调函数内监听
   * @param name 路由名称
   * @param result  返回携带的数据
   * @param animated 是否执行动画
   * @deprecated 建议使用popToNameWithResult()方法，该方法已经被弃用
   */
  public popNavWithResult<T>(name: string, result: T, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.popNavWithResult<T>(name, result, animated)
  }

  /**
   * 携带结果返回到根视图，即Navigation页面，可在onPopListener回调函数内监听
   * @param result 返回携带的数据
   * @param animated 是否执行动画
   */
  public popToRootWithResult<T>(result: T, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.popToRootWithResult<T>(result, animated)
  }

  /**
   * 携带结果返回到重定向页面，与redirect()方法搭配使用
   * @param result
   * @param animated
   */
  public finishWithResult<T>(result: T, animated: boolean = true) {
    this.updateCurrentStackName()
    const r = this.routerMgr.finishWithResult<T>(result, animated)
    return r
  }

  /**
   * 返回根视图，即Navigation页面
   */
  public clear() {
    this.updateCurrentStackName()
    this.routerMgr.clear()
  }

  /**
   * 获取所有路由栈的路由，如果在根视图则是一个空数组
   * @returns
   */
  public getAllPathName(): string[] {
    this.updateCurrentStackName()
    return this.routerMgr.getAllPathName()
  }

  /**
   * 获取路由栈栈顶的路由，在根视图中会返回null
   * @returns
   */
  public getTopPathName(): string | null {
    this.updateCurrentStackName()
    return this.routerMgr.getTopPathName()
  }

  /**
   * 按路由名称获取携带的参数
   * @param name 路由名称
   * @returns
   */
  public getParamByName(name: string): Record<string, ObjectOrNull>[] {
    this.updateCurrentStackName()
    return this.routerMgr.getParamByName(name)
  }

  /**
   * 获取当前页面的参数
   * @returns
   */
  public getParam(): ObjectOrNull {
    this.updateCurrentStackName()
    return this.routerMgr.getParam()
  }

  /**
   * 通过key获取当前页面的参数，建议带上默认值和泛型
   * @param key
   * @returns
   */
  public getParamByKey<P = ObjectOrNull>(key: string, defVal: ObjectOrNull = null): P {
    const p = this.getParam()
    try {
      if (ObjUtil.hasProperty(p, key)) {
        const o = p as Record<string, ObjectOrNull>
        const target = o[key]
        return target as P
      }
      return this.defaultValue<P>(defVal)
    } catch (err) {
      return defVal as P
    }
  }

  private defaultValue<P = ObjectOrNull>(defVal: ObjectOrNull = null): P {
    if (defVal instanceof Array) {
      return defVal as P
    }
    if (defVal instanceof Map) {
      return defVal as P
    }
    if (defVal instanceof Set) {
      return defVal as P
    }
    if (typeof defVal === 'number') {
      return defVal as P
    }
    if (typeof defVal === 'boolean') {
      return defVal as P
    }
    if (typeof defVal === 'string') {
      return defVal as P
    }
    if (typeof defVal === 'object') {
      return defVal as P
    }
    Logger.error('defaultValue is not support type ' + typeof defVal)
    throw new Error('defaultValue is not support type ' + typeof defVal)

    // return defVal as P

  }


  public hasKey(key: string): boolean {
    const p = this.getParam()
    return ObjUtil.hasProperty(p, key)
  }

  /**
   * 获取当前页面的@Route或@ZRoute注解中的参数
   * @returns
   */
  public getAnnotationParam() :RouteMetadata | undefined {
    this.updateCurrentStackName()
    return this.routerMgr.getAnnotationParam()
  }

  /**
   * 按路由名称删除指定的NavDestination
   * @param name 路由名称
   */
  public removeByName(name: string) {
    this.updateCurrentStackName()
    this.routerMgr.removeByName(name)
  }

  /**
   * 将指定的NavDestination移动到堆栈顶部
   * @param name
   */
  public moveToTop(name: string) {
    this.updateCurrentStackName()
    this.routerMgr.moveToTop(name)
  }



  /**
   * @see {@link ZRouter.animateMgr()}
   * @returns
   */
  public animateMgr(): NavAnimationMgr {
    this.routerMgr.animateMgr.setNavigation(this as object as NavDestBuilder<ObjectOrNull>)
    return this.routerMgr.animateMgr
  }
}