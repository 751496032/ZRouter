/**
 * @author: HZWei
 * @date: 2025/4/9
 * @desc:
 */
import { KeyConst, RouterConstants, Student } from "common_library";
import { ZRoute, ZRouter } from "routerapi";
import { ArrayList, HashMap } from "@kit.ArkTS";


@ZRoute({ name: RouterConstants.PAGE_BEFORE_PUSH, useTemplate: true, title: "跳转前拦截案例" })
@Component
export struct BeforePushPage {
  @State name :string =''
  @State age: number = 0
  @State score: number[] = []
  @State userInfo: Student = new Student()
  @State params : string = ''
  aboutToAppear(): void {
    this.userInfo.s_name = ''
    this.userInfo.s_age = 0
    if (ZRouter.getInstance().hasKey(KeyConst.KEY_NAME)) {
      this.name = ZRouter.getInstance().getParamByKey(KeyConst.KEY_NAME)
      this.age = ZRouter.getInstance().getParamByKey(KeyConst.KEY_AGE)
      this.score = ZRouter.getInstance().getParamByKey(KeyConst.KEY_SCORE)
      this.userInfo = ZRouter.getInstance().getParamByKey(KeyConst.KEY_USER_INFO)
      // 建议使用泛型
      const map = new Map<string,number>()
      map.set('a',1)
      const set = new Set<string>()
      set.add('a')

      const map1 = new HashMap<string,number>()

      if (map1 instanceof Map) {
        console.log('map1 is Map')
      }
      if (map1 instanceof HashMap) {
        console.log('map1 is HashMap')
      }

      const a = ZRouter.getParamByKey<number>('a',0)
      const b = ZRouter.getParamByKey<string>('b','hello')
      const c = ZRouter.getParamByKey<Student>('c',new Student())
      const d = ZRouter.getParamByKey<number[]>('d',[1,2,3])
      const e = ZRouter.getParamByKey<Student[]>('e',[new Student(),new Student()])
      const f = ZRouter.getParamByKey<boolean>('f',false)
      const g = ZRouter.getParamByKey<Map<string,number>>('g',map)
      const h = ZRouter.getParamByKey<Set<string>>('h',set)
      const hh =ZRouter.getParamByKey<Set<string>>('hh',undefined)
      const aa =ZRouter.getParamByKey<number>('aa',null)
      const hm =ZRouter.getParamByKey<HashMap<string,string>>('hm',new HashMap<string,string>())
      const al =ZRouter.getParamByKey<ArrayList<string>>('al',new ArrayList<string>())
      console.log('a:',a,'b:',b,'c:',c.s_name,'d:',d,'e:',e?.[0].s_name,'f:',f,'g:',g.get('a'),'h:',h.has('a'))
    }
    this.params = JSON.stringify(ZRouter.getInstance().getParam())
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

