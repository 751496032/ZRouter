import {  Service } from "routerapi";
import { promptAction } from "@kit.ArkUI";
import { IHarAService, RouterConstants } from "common_library";

@Service({ name: RouterConstants.SERVICE_HARA_IMPL })
export class HarAServiceImpl implements IHarAService {
  showToast(msg: string): void {
    promptAction.showToast({ message: msg })
  }

  getUserInfo(): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      resolve("hello harmonyos")
    })
  }

}

@Service({ name: "HarAService2" })
export class HarAServiceImpl2 implements IHarAService {
  showToast(msg: string): void {
    promptAction.showToast({ message: msg })
  }

  getUserInfo(): Promise<string> {
    return new Promise<string>((resolve, reject) => {
      resolve("hello harmonyos")
    })
  }

}