/**
 * @author: HZWei
 * @date: 2024/11/17
 * @desc:
 */
export class TemplateMgr {
    private static _instance: TemplateMgr = new TemplateMgr();

  public static getInstance(): TemplateMgr {
    return TemplateMgr._instance;
  }
    private constructor() {
    }

}