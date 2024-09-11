/**
 * @author: HZWei
 * @date: 2024/9/11
 * @desc:
 */
import { RouterMgr } from '../api/RouterMgr';
import { ObjectOrNull, OnPopResultCallback } from './Model';
import { INavOptions, NavOptionsImpl } from './NavOptions';

export class NavBuilder<T> {
  private options: INavOptions<T> = new NavOptionsImpl<T>();
  private routerMgr: RouterMgr

  constructor(routerMgr: RouterMgr) {
    this.routerMgr = routerMgr
  }

  public setAnimation(animation: boolean): NavBuilder<T> {
    this.options.animated = animation;
    return this;
  }

  public setLunchMode(mode: LaunchMode): NavBuilder<T> {
    this.options.lunchMode = mode;
    return this;
  }

  public setParam(param: ObjectOrNull): NavBuilder<T> {
    this.options.params = param;
    return this;
  }

  public setOnPopCallback(callback: OnPopResultCallback<T>): NavBuilder<T> {
    this.options.onPopCallback = callback;
    return this;
  }

  public navigation(name: string, replace: boolean = false): void {
    if (replace) {
      this.routerMgr.replacePathByName(name, this.options.params, this.options.animated)
      return
    }
    if (this.options.onPopCallback) {
      this.routerMgr.pushNavForResult<T>(name, this.options.params, this.options.onPopCallback)
    } else {
      this.routerMgr.push(name, this.options.params, this.options.animated)
    }

  }
}