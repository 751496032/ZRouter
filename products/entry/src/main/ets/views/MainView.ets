/**
 * @author: HZWei
 * @date: 2025/8/3
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import { ZRouter } from 'routerapi';
import { GlobalNavInterceptorMgr } from '../interceptors/interceptors';
import { AnimView } from './AnimView';
import { BottomNavigationBar } from './BottomNavigationBar';
import { HomeView } from './HomeView';
import { MineView } from './MineView';

@ComponentV2
export struct MainView {
  @Local currentIndex: number = 0;
  previousIndex: number = -1;

  aboutToAppear(): void {
    GlobalNavInterceptorMgr.onRootShow = () => {
      if (this.isLogin && this.previousIndex > 0) {
        this.currentIndex = this.previousIndex
      }
      if (this.previousIndex > 0) {
        this.previousIndex = -1
      }
    }
  }

  build() {
    Column() {
      Tabs({ index: this.currentIndex }) {
        TabContent() {
          HomeView()
        }

        TabContent() {
          AnimView()
        }

        TabContent() {
          MineView({onLogout: () => {
            this.currentIndex = 0
          }})
        }
      }
      .barMode(BarMode.Fixed)
      .scrollable(false)
      .layoutWeight(1)
      .barHeight(0)

      BottomNavigationBar({
        currentIndex: this.currentIndex!!,
        onItemClick: (index) => {
          if (index === 2) {
            if (!this.isLogin) {
              this.previousIndex = index
              ZRouter.getInstance().navigation(RouterConstants.LOGIN_PAGE)
              return true
            }
          }
          return false
        }

      })
    }.width('100%')
    .height('100%')
  }

  private get isLogin() {
    return AppStorage.get<boolean>('isLogin')
  }
}