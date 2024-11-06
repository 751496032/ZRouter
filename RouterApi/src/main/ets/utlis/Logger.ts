/**
 * @author: HZWei
 * @date: 2024/11/7
 * @desc:
 */
export default class Logger {
  static isShowLog : boolean

  static log(msg: string, ...args: Object[]) {
    if (Logger.hide()) return
    console.log("ZRouter -> " + msg, ...args)
  }

  static error(msg: string, ...args: Object[]) {
    if (Logger.hide()) return
    console.error("ZRouter -> " + msg, ...args)
  }

  private static hide(): boolean {
    return  !Logger.isShowLog
  }
}