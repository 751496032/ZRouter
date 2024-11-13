/**
 * @author: HZWei
 * @date: 2024/11/7
 * @desc:
 */
import { promptAction } from "@kit.ArkUI";

export  class ToastUtils {

  private constructor() {
  }

  static show(msg:string){
    promptAction.showToast({ message: msg })
  }
}