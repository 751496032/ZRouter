/**
 * @author: HZWei
 * @date: 2025/8/27
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import { ZRoute, ZRouter } from 'routerapi';
import { RouterMap } from 'routerapi/src/main/ets/model/RouterMap';

@ZRoute({name: RouterConstants.ROUTER_MAP_PAGE ,useTemplate:true ,hideTitleBar:false,title:'路由表信息'})
@Component
export struct RouterMapPage {
  @State routerMap: RouterMap[] = []
  aboutToAppear(): void {
    setTimeout(() => {
      this.routerMap = ZRouter.routerMap
    },100)

  }
  build() {
    Scroll(){
      Column({ space: 12 }) {
        Text(`路由数：${ZRouter.routerMap.length}`)
        Text(`${JSON.stringify({ routerMap: this.routerMap }, null, 2)}`)
      }
    }.scrollBar(BarState.Off)

  }
}