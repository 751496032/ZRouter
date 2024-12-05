/**
 * @author: HZWei
 * @date: 2024/9/11
 * @desc:
 */
import { RouterMgr } from '../api/RouterMgr';
import { ObjectOrNull, OnPopResultCallback, PopResult } from './Model';
import { INavOptions, NavOptionsImpl } from './NavOptions';
import { NavAnimationMgr } from '../animation/NavAnimationMgr';

export class NavBuilder<T> {
  private optionsImpl: INavOptions<T> = new NavOptionsImpl<T>();
  private routerMgr: RouterMgr

  get options(): INavOptions<T> {
    return this.optionsImpl
  }

  public static  create<T>(routerMgr: RouterMgr, stackName: string): NavBuilder<T> {
    return new NavBuilder<T>(routerMgr, stackName)
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
  public setAnimate(animated: boolean): NavBuilder<T> {
    this.optionsImpl.animated = animated;
    return this;
  }

  /**
   * 设置启动模式
   * @param mode
   * @returns
   */
  public setLunchMode(mode: LaunchMode): NavBuilder<T> {
    this.optionsImpl.lunchMode = mode;
    return this;
  }

  /**
   * 页面跳转携带的参数
   * @param param
   * @returns
   */
  public setParam(param: ObjectOrNull): NavBuilder<T> {
    this.optionsImpl.params = param;
    return this;
  }

  /**
   * 监听返回携带的结果
   * @param callback
   * @returns
   */
  public setPopListener(callback: OnPopResultCallback<T | ObjectOrNull>): NavBuilder<T> {
    this.optionsImpl.onPopListener = callback;
    return this;
  }

  /**
   * 开启跨多级页面回调监听，这种场景返回需要使用popNavWithResult()方法
   * @returns
   */
  public enableCrossPageParamReturn(): NavBuilder<T> {
    this.optionsImpl.enableCrossPageParamReturn = true;
    return this;
  }

  private updateCurrentStackName(): void {
    this.routerMgr.setCurrentStackName(this.optionsImpl.navStackName)
  }


  /**
   * 页面跳转
   * @param name 页面路由名称
   */
  public navigation(name: string): void {
    this.updateCurrentStackName()
    if (this.optionsImpl.onPopListener) {
      if (this.optionsImpl.enableCrossPageParamReturn) {
        this.routerMgr.pushNavForResult<T>(name, this.optionsImpl.params, this.optionsImpl.onPopListener,this)
      } else {
        this.routerMgr.pushForResult(name, this.optionsImpl.params, (data) => {
          let result = data.result
          let from = data.info.name
          let r = new PopResult<ObjectOrNull>()
          r.data = result
          r.from = from
          this.optionsImpl.onPopListener?.(r as PopResult<T>)
        }, this)
      }

    } else {
      this.routerMgr.push(name, this.optionsImpl.params, this.optionsImpl.animated, this)
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
    this.routerMgr.replacePathByName(name, this.optionsImpl.params, this.optionsImpl.animated, this)
  }

  /**
   * 重定位页面，建议在拦截器中使用，与finishWithResult()方法搭配使用
   * 比如用于拦截未登录的场景，当未登录时，在拦截器中重定向到登录页，当登录成功后，通过finishWithResult()方法关闭当前页，
   * 在onPopListener的回调函数中返回true则会继续跳转到未登录前的页面。
   * 注意：如果登录流程中间有多个页面，需要在finishWithResult()方法前手动调用pop()方法关闭。
   * @param name
   */
  public redirect(name: string) {
    this.updateCurrentStackName()
    if (this.optionsImpl.onPopListener) {
      this.routerMgr.redirectForResult2<T>(name, this, this.optionsImpl.onPopListener,this)
    } else {
      this.routerMgr.redirect(name, this)
    }
  }

  /**
   * 返回上一页
   * @param animated
   */
  public pop(animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.pop(animated)
  }


  /**
   * 返回指定路由名称的页面
   * @param name 路由名称
   * @param animated 是否执行动画
   */
  public popToName(name: string, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.popToName(name, animated)
  }

  /**
   * 携带结果返回上一页，可在onPopListener回调函数内监听
   * @param result 返回携带的数据
   * @param animated 是否执行动画
   */
  public popWithResult(result?: Object, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.popWithResult(result, animated)
  }

  /**
   * 携带结果返回到指定的页面(可以跨多级页面)，可在onPopListener回调函数内监听，前提是push时调用了enableCrossPageParamReturn()方法
   * @param name 路由名称
   * @param result  返回携带的数据
   * @param animated 是否执行动画
   */
  public popNavWithResult<T>(name: string, result?: T, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.popNavWithResult<T>(name, result, animated)
  }

  /**
   * 携带结果返回到根视图，即Navigation页面，可在onPopListener回调函数内监听
   * @param result 返回携带的数据
   * @param animated 是否执行动画
   */
  public popToRootWithResult<T>(result?: T, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.popToRootWithResult<T>(result, animated)
  }

  /**
   * 携带结果返回到重定向页面，与redirect()方法搭配使用
   * @param result
   * @param animated
   */
  public finishWithResult<T>(result?: T, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.finishWithResult<T>(result, animated)
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
   * @param name
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
   * 获取当前页面的@Route或@ZRoute注解中的参数
   * @returns
   */
  public getAnnotationParam() {
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
   * @deprecated
   * @see {@link ZRouter.animateMgr()}
   * @returns
   */
  public animateMgr(): NavAnimationMgr {
    return this.routerMgr.animateMgr
  }
}