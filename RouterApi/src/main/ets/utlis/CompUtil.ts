import { RouterInfo } from "../model/RouterInfo";

export class CompUtil{
  private constructor() {
  }

  static getRouterInfo(component: object): RouterInfo {
    const nav = component['queryNavDestinationInfo']
    return RouterInfo.create(`${nav['name']}`, `${nav['navDestinationId']}`, nav['param'], `${nav['navDestinationId']}`)
  }
}