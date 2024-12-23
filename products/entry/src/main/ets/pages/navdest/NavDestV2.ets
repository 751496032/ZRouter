
import { RouterConstants } from '@hzw/common_library';
import { ZRoute } from 'routerapi';
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
  @Param viewModel: NavDestV2ViewModel = new NavDestV2ViewModel()
  build() {
    Column({space : 10}){
      Text(`${this.viewModel.counter}`)
      Button("+1").onClick((event: ClickEvent) => {
        this.viewModel.counter ++
      })
    }
  }
}