/**
 * @author: HZWei
 * @date: 2024/12/22
 * @desc:
 */
import { KeyConst, RouterConstants, Student } from "common_library";
import { Route, ZRoute, ZRouter } from "routerapi";
import { ArrayList, HashMap } from "@kit.ArkTS";

// 组件间传递参数暂不支持模板化
@Route({
  name: RouterConstants.PAGE_PARAM2,
  param: {
    "name": { default: null },
    "age": { default: 22 },
    "score": { default: [80, 90, 100] },
    "userInfo": { default: new Student() }
  }
})
@Component
export struct ParamPage2 {
  @State name :string =''
  @State age: number = 0
  @State score: number[] = []
  @State userInfo: Student = new Student()

  aboutToAppear(): void {

  }

  build() {
    NavDestination(){
      Column({ space: 10 }) {
        Text(`name: ${this.name}`)
        Text(`age: ${this.age}`)
        Text(`score: ${this.score}`)
        Text(`userInfo: ${JSON.stringify(this.userInfo)}`)
      }
      .margin({ top: 30 })
    }

  }
}

