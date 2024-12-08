import { RouterConstants, ToastUtils } from '@hzw/common_library';
import { LifecycleState, Route, ZRouter } from 'routerapi';
import { CustomCompLifecycleObserver } from './CustomCompLifecycleObserver';

/**
 * @author: HZWei
 * @date: 2024/11/13
 * @desc:
 */

@Route({ name: RouterConstants.CUSTOM_COMPONENT_CHILD_VIEW, useTemplate: true, title: "NavDest模板化案例" })
@Component
export struct ChildView {
  // 通过@Consume获取生命周期观察者
  // 生命周期监听方式一
  @Consume lifecycleObserver: CustomCompLifecycleObserver

  private  lastBackTime: number = 0

  aboutToAppear(): void {
    // 生命周期监听方式二
    // 设置NavDest模板页面的生命周期监听
    ZRouter.addLifecycleObserver((state, router) => {
      console.log("ChildView CustomComponentView  ", state, router?.navDestinationId)
      if (state === LifecycleState.ON_BACK_PRESS) {
        // 拦截返回事件，与可以在lifecycleObserver做拦截处理
        if (Date.now() - this.lastBackTime < 2000 || this.lastBackTime === 0) {
          if (Date.now() - this.lastBackTime < 2000 ) {
            return false
          }
          this.lastBackTime = Date.now()
          ToastUtils.show("再按一次退出")
          return true
        }
        return false
      }
      return false

    })
  }

  build() {
    Column({ space: 15 }) {
      Text("NavDest页面模板化：即页面无需用NavDestination组件包裹，在编译阶段会自动生成对应的逻辑，" +
        "提供了额外的生命周期回调，并支持自定义NavDestination属性。")
        .padding(20)
      Text((this.lifecycleObserver.counter) + "")
      Button("+1 - lifecycleObserver").onClick((event: ClickEvent) => {
        this.lifecycleObserver.counter++
      })

      Button("CustomComp2").onClick((event: ClickEvent) => {
        ZRouter.getInstance()
          .navigation(RouterConstants.CUSTOM_COMPONENT_CHILD_VIEW)
      })

      Button("CustomComp-hsp").onClick((event: ClickEvent) => {
        ZRouter.getInstance()
          .navigation(RouterConstants.CUSTOM_COMPONENT_VIEW_HSP)
      })

    }
  }
}


