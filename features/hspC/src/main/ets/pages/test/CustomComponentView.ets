import { RouterConstants } from '@hzw/common_library';
import { ZRoute, ZRouter } from 'routerapi';
import { CustomCompLifecycleObserver } from './CustomCompLifecycleObserver';

/**
 * @author: HZWei
 * @date: 2024/11/13
 * @desc:
 */

@ZRoute({ name: RouterConstants.CUSTOM_COMPONENT_VIEW_HSP, useTemplate: true })
@Component
export struct ChildView {
  @Consume viewModel: CustomCompLifecycleObserver
  aboutToAppear(): void {
    ZRouter.addLifecycleObserver((state, router) => {
      console.log("ChildView hsp addObserver ", state, router?.navDestinationId)
    })
  }

  build() {
    Column({ space: 15 }) {
      Text(this.viewModel.counter + "")
      Button("+1").onClick((event: ClickEvent) => {
        this.viewModel.counter++
      })

      Button("CustomComp-hsp").onClick((event: ClickEvent) => {
        ZRouter.getInstance().navigation(RouterConstants.CUSTOM_COMPONENT_VIEW_HSP)
      })

      Button('harAMain').onClick((event: ClickEvent) => {
        ZRouter.getInstance()
          .navigation(RouterConstants.HARA_MAIN_PAGE)
      })

    }
    .margin({top:30})
  }
}


