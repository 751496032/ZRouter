import { IProvider } from "routerapi";
import { promptAction } from "@kit.ArkUI";
import { IHarAService } from "common_library";

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