/**
 * @author: HZWei
 * @date: 2024/8/18
 * @desc:
 */
import { InitConfig, ObjectOrNull } from '../model/Model'
import { ObjUtil } from './ObjUtil'

/**
 * @deprecated
 */
export default class LogUtil {
  static config : InitConfig

  static log(msg: string, ...args: ObjectOrNull[]) {
    if (LogUtil.hide()) return
    console.log("ZRouter -> " + msg, ...args)
  }

  static error(msg: string, ...args: ObjectOrNull[]) {
    if (LogUtil.hide()) return
    console.error("ZRouter -> " + msg, ...args)
  }

  private static hide(): boolean {
    return ObjUtil.isEmpty(LogUtil.config) || !LogUtil.config.isShowLog
  }
}