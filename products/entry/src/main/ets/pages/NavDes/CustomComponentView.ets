import { RouterConstants } from '@hzw/common_library';
import { ILifecycleObserver, Lifecycle, LifecycleEvent, LifecycleRegistry,
  LifecycleRegistryOrNull,
  Route,
  RouterInfo} from 'routerapi';
import { util } from '@kit.ArkTS';

/**
 * @author: HZWei
 * @date: 2024/11/13
 * @desc:
 */

@Route({ name: RouterConstants.CUSTOM_COMPONENT_VIEW })
@Component
export struct CustomComponentView {
  @Lifecycle lifecycle : LifecycleRegistry = LifecycleRegistry.create(this)
  private  isShown = false
  aboutToAppear(): void {
    console.log('CustomComponentView aboutToAppear')
    this.lifecycle.addListener((e: LifecycleEvent, r?: RouteInfo) => {
      // console.log("CustomComponentView lifecycle: ", e, r?.name)
    })
    this.lifecycle.addObserver<ILifecycleObserver>({})
  }

  build() {
    NavDestination() {
      ChildView({ lifecycle: this.lifecycle })
        .onAppear(() => {
          // RouterInfo.create()
          console.log('ChildView CustomComponentView aboutToAppear 11')
        })
    }
    .onShown(() => {
      if (!this.isShown) {
        const navDesInfo = this.queryNavDestinationInfo()
        const routerInfo = RouterInfo.create(navDesInfo?.name +  "", navDesInfo?.navigationId + "", navDesInfo?.param,
          navDesInfo?.navDestinationId)
        this.lifecycle.getCurrentObserver()?.onShown?.(routerInfo)
      }
      this.isShown = true
      console.log('ChildView CustomComponentView aboutToAppear 11')
    })
  }
}

@Component
export struct ChildView {
  lifecycle: LifecycleRegistryOrNull
  // @Lifecycle lifecycle2 : LifecycleRegistry = LifecycleRegistry.create(this)

  onDidBuild(): void {
    console.log('ChildView CustomComponentView onDidBuild')
    this.lifecycle?.getCurrentObserver<ILifecycleObserver>()
  }

  aboutToAppear(): void {
    console.log('ChildView CustomComponentView aboutToAppear')
    // this.lifecycle2.addListener((e:LifecycleEvent,r?:RouteInfo)=>{
    //   console.log("ChildView lifecycle2: ", e, r?.name)
    // })
    this.lifecycle?.addListener((e: LifecycleEvent, r?: RouteInfo) => {
      console.log("CustomComponentView ChildView lifecycle: ", e, r?.name)
    })
  }

  build() {
    Column(){
      Text("测试")
    }
  }
}


