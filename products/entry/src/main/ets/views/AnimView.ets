/**
 * @author: HZWei
 * @date: 2025/5/24
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library'
import { ZRouter } from 'routerapi'

@ComponentV2
export struct AnimView {
  build() {
    Column({ space: 10 }) {
      Button("转场动画").onClick((event: ClickEvent) => {
        ZRouter.getInstance().navigation(RouterConstants.ANIM_DEMO)
      })
    }
  }
}