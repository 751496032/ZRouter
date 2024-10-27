/**
 * @author: HZWei
 * @date: 2024/10/27
 * @desc:
 */

export class ObserverState {
  private _routerName?: string | undefined

  public get routerName(): string | undefined {
    return this._routerName
  }

  constructor(routerName?: string) {
    this._routerName = routerName
  }


}