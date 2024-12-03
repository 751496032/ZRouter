import { RouterConstants } from '@hzw/common_library';
import { Logger } from '@hzw/logger';
import {
  Lifecycle,
  LifecycleEvent,
  LifecycleRegistry,
  Route,
  ZRouter
} from 'routerapi';
import { CustomCompLifecycleObserver } from './CustomCompLifecycleObserver';

/**
 * @author: HZWei
 * @date: 2024/11/13
 * @desc:
 */

@Route({ name: RouterConstants.CUSTOM_COMPONENT_VIEW_HSP })
@Component
export struct CustomComponentView {
  @Lifecycle lifecycle: LifecycleRegistry = LifecycleRegistry.create(this)
  @Provide lifecycleObserver: CustomCompLifecycleObserver = new CustomCompLifecycleObserver()
  private navDestinationId: string | undefined = ''

  aboutToAppear(): void {
    this.lifecycle.addListener((event, router) => {
      switch (event) {
        case LifecycleEvent.ON_WILL_APPEAR:
          this.navDestinationId = router?.navDestinationId
          ZRouter.templateMgr().register(this.navDestinationId)
          break;
        default:
          ZRouter.templateMgr().dispatch(this.navDestinationId, event, router)
          break;

      }

    })
  }

  build() {
    NavDestination() {
      ChildView()
    }
    .onReady((context) => {
      if (!this.navDestinationId) {
        this.navDestinationId = context.navDestinationId
      }
      console.log("CustomComponentView onReady", context.navDestinationId, context.pathInfo.name)
    })
    .onBackPressed(() => {
      const r = ZRouter.templateMgr().dispatch(this.navDestinationId, LifecycleEvent.ON_BACK_PRESS)
      return  (typeof r === 'boolean' && r)
    })
    .title("测试-hsp")
    .hideTitleBar(false)
  }
}

@Component
export struct ChildView {
  @Consume lifecycleObserver: CustomCompLifecycleObserver
  aboutToAppear(): void {
    ZRouter.addLifecycleObserver((state, router) => {
      console.log("ChildView CustomComponentView addObserver ", state, router?.navDestinationId)
    })
  }

  build() {
    Column({ space: 15 }) {
      Text(this.lifecycleObserver.counter + "")
      Button("+1").onClick((event: ClickEvent) => {
        this.lifecycleObserver.counter++
      })

      Button("CustomComp-hsp").onClick((event: ClickEvent) => {
        ZRouter.getInstance().navigation(RouterConstants.CUSTOM_COMPONENT_VIEW_HSP)
      })

      Button("CustomComp2-hsp").onClick((event: ClickEvent) => {
        ZRouter.getInstance()
          .setLunchMode(LaunchMode.MOVE_TO_TOP_SINGLETON)
          .navigation(RouterConstants.CUSTOM_COMPONENT_VIEW_HSP)
      })

    }
  }
}


