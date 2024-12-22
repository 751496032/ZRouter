/**
 * @author: HZWei
 * @date: 2024/12/22
 * @desc:
 */
import { KeyConst, RouterConstants, Student } from "common_library";
import { ZRoute, ZRouter } from "routerapi";


@ZRoute({ name: RouterConstants.PAGE_PARAM, useTemplate: true, title: "获取携带的参数案例" })
@Component
export struct ParamPage {
  @State name :string =''
  @State age: number = 0
  @State score: number[] = []
  @State userInfo: Student = new Student()
  @State params : string = ''
  aboutToAppear(): void {
    this.userInfo.s_name = ''
    this.userInfo.s_age = 0
    this.name = ZRouter.getInstance().getParamByKey(KeyConst.KEY_NAME)
    this.age = ZRouter.getInstance().getParamByKey(KeyConst.KEY_AGE)
    this.score = ZRouter.getInstance().getParamByKey(KeyConst.KEY_SCORE)
    this.userInfo = ZRouter.getInstance().getParamByKey(KeyConst.KEY_USER_INFO)
    this.params = JSON.stringify(ZRouter.getInstance().getParam() || "")
  }

  build() {
    Column({ space: 10 }) {
      Text('getParamByKey: ')
        .fontWeight(FontWeight.Bold)
        .padding(10)
      Text(`name: ${this.name}`)
      Text(`age: ${this.age}`)
      Text(`score: ${this.score}`)
      Text(`userInfo: ${JSON.stringify(this.userInfo)}`)
      Text('getParam: ')
        .fontWeight(FontWeight.Bold)
        .padding(10)
      Text(`all params: ${this.params}`)
    }
    .margin({ top: 30 })

  }
}

