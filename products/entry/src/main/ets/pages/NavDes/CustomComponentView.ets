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
import { NavDesModifier } from './NavDestinationAttr';

/**
 * @author: HZWei
 * @date: 2024/11/13
 * @desc:
 */

@Route({ name: RouterConstants.CUSTOM_COMPONENT_VIEW })
@Component
export struct CustomComponentView {
  @Lifecycle lifecycle: LifecycleRegistry = LifecycleRegistry.create(this)
  @Provide lifecycleObserver: CustomCompLifecycleObserver = new CustomCompLifecycleObserver()
  @Provide modifier: NavDesModifier = new NavDesModifier()
  private navDestinationId: string | undefined = ''

  aboutToAppear(): void {
    console.log('CustomComponentView aboutToAppear')
    this.lifecycle.addObserver(this.lifecycleObserver)
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
      this.lifecycleObserver.onReady(context)
    })
    .onBackPressed(() => {
      const r =  ZRouter.templateMgr().dispatch(this.navDestinationId, LifecycleEvent.ON_BACK_PRESS)
      return this.lifecycleObserver.onBackPress() || (typeof r === 'boolean' && r)
    })
    .hideTitleBar(true)
    .attributeModifier(this.modifier)
  }
}

@Route({ name: RouterConstants.CUSTOM_COMPONENT_CHILD_VIEW, useTemplate: true })
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

      Button("CustomComp").onClick((event: ClickEvent) => {
        ZRouter.getInstance().navigation(RouterConstants.CUSTOM_COMPONENT_VIEW)
      })

      Button("CustomComp2").onClick((event: ClickEvent) => {
        ZRouter.getInstance()
          .setLunchMode(LaunchMode.MOVE_TO_TOP_SINGLETON)
          .navigation(RouterConstants.CUSTOM_COMPONENT_VIEW)
      })

      Button("CustomComp-hsp").onClick((event: ClickEvent) => {
        ZRouter.getInstance()
          .navigation(RouterConstants.CUSTOM_COMPONENT_VIEW_HSP)
      })

      Button("LifecycleComp").onClick((event: ClickEvent) => {
        ZRouter.getInstance().navigation(RouterConstants.LIFECYCLE_CASE_VIEW)
      })
    }
  }
}


