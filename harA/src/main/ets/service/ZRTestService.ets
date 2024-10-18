import { ServiceMgr } from "routerapi";
import { TestService } from "./TestService";
// name对应注解的name值
ServiceMgr.instance.addService("testService", new TestService())