import { RouterConstants } from 'common_library';
import { ZRouter } from "routerapi";
import { HarAServiceImpl } from './HarAServiceImpl';

// import { TestService } from "./TestService";
// name对应注解的name值
ZRouter.addService(RouterConstants.SERVICE_HARA_IMPL, new HarAServiceImpl())

console.log("harA服务已注册")