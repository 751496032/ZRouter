import { RouterConstants } from '@hzw/common_library';
import { ILifecycleObserver, Lifecycle, LifecycleEvent, LifecycleRegistry, Route } from 'routerapi';

/**
 * @author: HZWei
 * @date: 2024/11/13
 * @desc:
 */

@Route({ name: RouterConstants.CUSTOM_COMPONENT_VIEW })
@Component
export struct CustomComponentView {
  @Lifecycle lifecycle : LifecycleRegistry = LifecycleRegistry.create(this)
  aboutToAppear(): void {
    console.log('CustomComponentView aboutToAppear')
    this.lifecycle.addListener((e: LifecycleEvent, r?: RouteInfo) => {
      console.log("CustomComponentView lifecycle: ", e, r?.name)
    })
    this.lifecycle.addObserver<ILifecycleObserver>({})
  }

  build() {
    NavDestination(){
      ChildView({ lifecycle: this.lifecycle })
    }
  }
}

@Component
export struct ChildView {
  lifecycle: LifecycleRegistry | undefined
  // @Lifecycle lifecycle2 : LifecycleRegistry = LifecycleRegistry.create(this)

  onDidBuild(): void {
    console.log('CustomComponentView ChildView onDidBuild')
  }

  aboutToAppear(): void {
    console.log('ChildView aboutToAppear')
    console.log('CustomComponentView ChildView aboutToAppear')
    // this.lifecycle2.addListener((e:LifecycleEvent,r?:RouteInfo)=>{
    //   console.log("ChildView lifecycle2: ", e, r?.name)
    // })
    this.lifecycle?.addListener((e:LifecycleEvent,r?:RouteInfo) => {
      console.log("CustomComponentView ChildView lifecycle: ", e, r?.name)
    })
  }

  build() {
    Column(){
      Text("测试")
    }
  }
}


