/**
 * @author: HZWei
 * @date: 2025/8/3
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import { ZRoute } from 'routerapi';
import { MainView } from '../views/MainView';

@ZRoute({ name: RouterConstants.MAIN_PAGE, useTemplate: true })
@ComponentV2
export struct MainPage{
  build() {
    Stack(){
      MainView()
    }
  }
}
