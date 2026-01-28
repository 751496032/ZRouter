
import { RouterConstants } from '@hzw/common_library';
import { ZRoute, ZRouter } from 'routerapi';
import { NavDestV2ViewModel } from './NavDestV2ViewModel';


/**
 * @author: HZWei
 * @date: 2024/12/23
 * @desc:
 * loAttributeName属性名称也可以设置全局的，在编译插件配置初始化lifecycleObserverAttributeName:viewModel
 */
@ZRoute({ name: RouterConstants.PAGE_NAVDEST_TEMPLATE_V2, useTemplate: true, useV2: true, loAttributeName:"viewModel", hideTitleBar: false, title: 'NavDestV2模板化案例' })
@Preview
@ComponentV2
export struct NavDestV2 {
  // 方式1：在ViewModel中监听生命周期函数
  @Param viewModel: NavDestV2ViewModel = new NavDestV2ViewModel()
  private static readonly TAG = 'NavDestV2 addLifecycleObserver'

  aboutToAppear(): void {
    // 方式2：在组件中可以监听生命周期函数
    ZRouter.addLifecycleObserver((e, r) => {
      console.log(NavDestV2.TAG, e)
    })
  }

  build() {
    Column({space : 10}){
      Text(`${this.viewModel.counter}`)
      Button("+1").onClick((event: ClickEvent) => {
        if (this.viewModel.counter === 0) {
          ZRouter.addLifecycleObserver((e, r) => {
            console.log(NavDestV2.TAG, " onClick ", e)
          })
        }
        this.viewModel.counter ++


      })
    }
  }
}