import { RouterConstants } from '@hzw/common_library';
import { ILifecycleObserver, Lifecycle, LifecycleEvent, LifecycleRegistry,
  LifecycleRegistryOrNull,
  Route,
  RouterInfo,
  ZRouter} from 'routerapi';
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
  @Lifecycle lifecycle : LifecycleRegistry = LifecycleRegistry.create(this)
  @Provide lifecycleObserver: CustomCompLifecycleObserver = new CustomCompLifecycleObserver()
  aboutToAppear(): void {
    console.log('CustomComponentView aboutToAppear')
    this.lifecycle.addObserver(this.lifecycleObserver)

  }

  build() {
    NavDestination() {
      ChildView()
    }
    .onReady((data) => {
      this.lifecycleObserver.onReady(data)
    })
    .onBackPressed(() => {
      return this.lifecycleObserver.onBackPress()
    })
    .attributeModifier(new NavDesModifier())
  }
}

@Component
export struct ChildView{
  @Consume lifecycleObserver: CustomCompLifecycleObserver


  aboutToAppear(): void {
    console.log('ChildView CustomComponentView aboutToAppear')

  }

  build() {
    Column({space : 15}){
      Text(this.lifecycleObserver?.counter  + "")
      Button("+1").onClick((event: ClickEvent) => {
        if (this.lifecycleObserver?.counter) {
          this.lifecycleObserver.counter++
        }

      })

      Button("CustomComp").onClick((event: ClickEvent) => {
        ZRouter.getInstance().navigation(RouterConstants.CUSTOM_COMPONENT_VIEW)
      })
    }
  }
}


