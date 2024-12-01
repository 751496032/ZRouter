import { RouterConstants } from '@hzw/common_library';
import { Logger } from '@hzw/logger';
import {
  Lifecycle,
  LifecycleEvent,
  LifecycleRegistry,
  Route,
  templateMgr,
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
  modifier: NavDesModifier = new NavDesModifier()
  private navDestinationId: string | undefined = ''

  aboutToAppear(): void {
    console.log('CustomComponentView aboutToAppear')
    this.lifecycle.addObserver(this.lifecycleObserver)
    this.lifecycle.addListener((event, router) => {
      switch (event) {
        case LifecycleEvent.ON_WILL_APPEAR:
          this.navDestinationId = router?.navDestinationId
          templateMgr.register(this.navDestinationId)
          break;
        default:
          templateMgr.dispatch(this.navDestinationId, event, router)
          break;

      }

    })
  }

  build() {
    NavDestination() {
      ChildView()
        .onAppear(() => {
          // console.log("CustomComponentView ChildView onAppear", this.queryNavDestinationInfo()?.navigationId)
        })
    }
    .onReady((context) => {
      if (!this.navDestinationId) {
        this.navDestinationId = context.navDestinationId
      }
      console.log("CustomComponentView onReady", context.navDestinationId, context.pathInfo.name)
      this.lifecycleObserver.onReady(context)
    })
    .onBackPressed(() => {
      const r = templateMgr.dispatch(this.navDestinationId, LifecycleEvent.ON_BACK_PRESS)
      return this.lifecycleObserver.onBackPress() || (typeof r === 'boolean' && r)
    })
    .onAppear(() => {
      console.log("CustomComponentView onAppear")
    })
    .onWillAppear(() => {
      console.log("CustomComponentView onWillAppear", ZRouter.getLastNavDestinationId())
    })
    .onWillShow(() => {
      console.log("CustomComponentView onWillShow")
    })
    .onShown(() => {
      console.log("CustomComponentView onShown", this.queryNavDestinationInfo()?.name)
    })
    .onAttach(() => {
      console.log("CustomComponentView onAttach")
    })
    .onDetach(() => {
      console.log("CustomComponentView onDetach")
    })
    .title("测试")
    .hideTitleBar(true)
    .attributeModifier(this.modifier)
  }
}

@Component
export struct ChildView {
  @Consume lifecycleObserver: CustomCompLifecycleObserver

  aboutToAppear(): void {
    // console.log('ChildView CustomComponentView aboutToAppear', this.queryNavDestinationInfo()?.name)
    // Logger.i(this.queryNavDestinationInfo())
    templateMgr.addObserver((state, router) => {
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

      Button("LifecycleComp").onClick((event: ClickEvent) => {
        ZRouter.getInstance().navigation(RouterConstants.LIFECYCLE_CASE_VIEW)
      })
    }
  }
}


