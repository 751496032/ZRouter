/**
 * @author: HZWei
 * @date: 2024/10/20
 * @desc:
 */
import { IHspCService, RouterConstants } from "@hzw/common_library";
import { Service } from "routerapi";

@Service({name : RouterConstants.SERVICE_HSPC_IMPL})
export class HspCServiceImpl implements IHspCService{
  getDataFromHspC(): Promise<string> {
    return new Promise((resolve)=>{
      resolve("来自hspC的数据： hello world")
    })
  }

}