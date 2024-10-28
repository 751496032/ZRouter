export class RouterInfo {
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