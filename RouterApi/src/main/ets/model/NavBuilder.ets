/**
 * @author: HZWei
 * @date: 2024/9/11
 * @desc:
 */
import { RouterMgr } from '../api/RouterMgr';
import { ILifecycleObserver } from '../lifecycle/ILifecycleObserver';
import { ObjectOrNull, OnPopResultCallback, PopResult } from './Model';
import { INavOptions, NavOptionsImpl } from './NavOptions';

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

  public setAnimate(animated: boolean): NavBuilder<T> {
    this.optionsImpl.animated = animated;
    return this;
  }

  public setLunchMode(mode: LaunchMode): NavBuilder<T> {
    this.optionsImpl.lunchMode = mode;
    return this;
  }

  public setParam(param: ObjectOrNull): NavBuilder<T> {
    this.optionsImpl.params = param;
    return this;
  }

  public setPopListener(callback: OnPopResultCallback<T | ObjectOrNull>): NavBuilder<T> {
    this.optionsImpl.onPopListener = callback;
    return this;
  }

  public enableCrossPageParamReturn(): NavBuilder<T> {
    this.optionsImpl.enableCrossPageParamReturn = true;
    return this;
  }

  private updateCurrentStackName(): void {
    this.routerMgr.setCurrentStackName(this.optionsImpl.navStackName)
  }

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

  public push(name: string) {
    this.navigation(name)
  }

  public replace(name: string) {
    this.updateCurrentStackName()
    this.routerMgr.replacePathByName(name, this.optionsImpl.params, this.optionsImpl.animated, this)
  }


  public redirect(name: string) {
    this.updateCurrentStackName()
    if (this.optionsImpl.onPopListener) {
      this.routerMgr.redirectForResult2<T>(name, this, this.optionsImpl.onPopListener,this)
    } else {
      this.routerMgr.redirect(name, this)
    }
  }

  public pop(animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.pop(animated)
  }


  public popToName(name: string, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.popToName(name, animated)
  }


  public popWithResult(result?: Object, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.popWithResult(result, animated)
  }

  public popNavWithResult<T>(name: string, result?: T, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.popNavWithResult<T>(name, result, animated)
  }

  public popToRootWithResult<T>(result?: T, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.popToRootWithResult<T>(result, animated)
  }

  public finishWithResult<T>(result?: T, animated: boolean = true) {
    this.updateCurrentStackName()
    this.routerMgr.finishWithResult<T>(result, animated)
  }


  public clear() {
    this.updateCurrentStackName()
    this.routerMgr.clear()
  }

  public getAllPathName(): string[] {
    this.updateCurrentStackName()
    return this.routerMgr.getAllPathName()
  }

  public getTopPathName(): string | null {
    this.updateCurrentStackName()
    return this.routerMgr.getTopPathName()
  }


  public getParamByName(name: string): Record<string, ObjectOrNull>[] {
    this.updateCurrentStackName()
    return this.routerMgr.getParamByName(name)
  }

  public getParam(): ObjectOrNull {
    this.updateCurrentStackName()
    return this.routerMgr.getParam()
  }

  public getAnnotationParam() {
    this.updateCurrentStackName()
    return this.routerMgr.getAnnotationParam()
  }

  public removeByName(name: string) {
    this.updateCurrentStackName()
    this.routerMgr.removeByName(name)
  }

  public moveToTop(name: string) {
    this.updateCurrentStackName()
    this.routerMgr.moveToTop(name)
  }

  public addGlobalLifecycleObserver<IL extends ILifecycleObserver>(observer: IL) {
    this.routerMgr.lifecycleMgr.addGlobalObserver(observer)
  }

}