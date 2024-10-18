import { IProvider } from "routerapi";
import { promptAction } from "@kit.ArkUI";

export class TestService implements IProvider {
  showToast(msg: string) {
    promptAction.showToast({ message: msg })
  }
}