import { RouterConstants } from "@hzw/common_library";
import { Route, ZRouter } from "routerapi";
import { GlobalLifecycleObserverImpl } from "../../model/GlobalLifecycleObserverImpl";

/**
 * @author: HZWei
 * @date: 2024/11/7
 * @desc: 生命周期管理案例
 * 1、日志过滤：LifecycleMgr
 * 2、ui组件的名称要具有唯一性
 */
@Route({ name: RouterConstants.LIFECYCLE_CASE_VIEW })
@Component
export struct LifecycleCaseView {

  aboutToAppear(): void {
  }

  build() {
    NavDestination() {
      Column({ space: 15 }) {
        Text('日志过滤：LifecycleMgr \n ui组件的名称要具有唯一性')
        Button('Lifecycle1View - addObserver').onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.LIFECYCLE1_VIEW)
        })

        Button('Lifecycle2View - addObserver').onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.LIFECYCLE2_VIEW)
        })

        Button('Lifecycle3View - addListener').onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.LIFECYCLE3_VIEW)
        })

        Button('Lifecycle4View - ViewModel').onClick((event: ClickEvent) => {
          ZRouter.getInstance().navigation(RouterConstants.LIFECYCLE4_VIEW)
        })

        Button('添加全局生命周期监听').onClick((event: ClickEvent) => {
          ZRouter.addGlobalLifecycleObserver(new GlobalLifecycleObserverImpl())
        })

      }.justifyContent(FlexAlign.Center)
    }.title('生命周期函数管理')
  }
}