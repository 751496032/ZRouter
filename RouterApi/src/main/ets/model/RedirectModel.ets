/**
 * @author: HZWei
 * @date: 2024/8/26
 * @desc:
 */
import { RedirectType } from "./Const"

export class RedirectInfo {
  name: string
  head: boolean
  type: RedirectType | undefined = RedirectType.PUSH

  constructor(name: string = '', head: boolean = false) {
    this.name = name
    this.head = head
  }
}
