import { IProvider, Service } from "routerapi";
import { promptAction } from "@kit.ArkUI";
import { IHarAService } from "common_library";

@Service({ name: "HarAServiceImpl" })
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