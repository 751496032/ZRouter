
export class RouterInfo {
  /**
   * 通用组件的生命周期，只有name属性，其他属性为空，name为组件的类名
   */
  name: string
  navigationId: string
  param: Object
  navDestinationId: string;

  constructor(name: string, navigationId: string, param: Object, navDestinationId: string) {
    this.name = name;
    this.navigationId = navigationId;
    this.param = param;
    this.navDestinationId = navDestinationId;
  }

  static create(name: string, navigationId: string, param: Object, navDestinationId: string): RouterInfo {
    return new RouterInfo(name, navigationId, param, navDestinationId)
  }
}