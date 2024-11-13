import { RouterConstants } from '@hzw/common_library';
import { Lifecycle, LifecycleRegistry, Route } from 'routerapi';

/**
 * @author: HZWei
 * @date: 2024/11/13
 * @desc:
 */

@Route({ name: RouterConstants.CUSTOM_COMPONENT_VIEW })
@Component
struct CustomComponentView {
  @Lifecycle lifecycle : LifecycleRegistry = LifecycleRegistry.create(this)
  build() {
    NavDestination(){
      ChildView({ lifecycle: this.lifecycle })
    }
  }
}

@Component
struct ChildView {
  lifecycle: LifecycleRegistry | undefined

  aboutToAppear(): void {
    this.lifecycle?.addListener(() => {

    })
  }

  build() {

  }
}


