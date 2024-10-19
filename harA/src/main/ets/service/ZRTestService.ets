import { ServiceMgr } from "routerapi";
import { HarAServiceImpl } from './HarAServiceImpl';

// import { TestService } from "./TestService";
// name对应注解的name值
ServiceMgr.instance.addService("HarAServiceImpl", new HarAServiceImpl())

console.log("服务已注册")