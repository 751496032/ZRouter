import { Logger } from "@hzw/logger"
import { ZRouter } from "../../api/Router"

class TemplateMgr {


  addObserver(comp:object) {
    let name = ZRouter.getInstance(ZRouter.getCurrentStackName()).getTopPathName()
    Logger.i("TemplateMgr ", name)
  }


}
export const templateMgr = new TemplateMgr()

