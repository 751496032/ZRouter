/**
 * @author: HZWei
 * @date: 2024/8/18
 * @desc:
 */
import { InitConfig, ObjectOrNull } from '../model/Model'
import { ObjectUtil } from './ObjectUtil'

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
    return ObjectUtil.isEmpty(LogUtil.config) || !LogUtil.config.isShowLog
  }
}