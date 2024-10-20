import { RouterConstants } from '@hzw/common_library';
import {  ZRouter } from "routerapi";
import { HspCServiceImpl } from './HspCServiceImpl';

// name对应注解的name值
ZRouter.addService(RouterConstants.SERVICE_HSPC_IMPL, new HspCServiceImpl())

console.log("hspC服务已注册")