/**
 * @author: HZWei
 * @date: 2024/8/26
 * @desc:
 */
import { Route, ZRouter } from 'routerapi';
import { promptAction } from '@kit.ArkUI';
import { RouterConstants } from 'common_library';


@Route({ name: RouterConstants.LoginVerifyCodePage })
@Component
@Preview
export struct LoginVerifyCodePage {
  @State code: string = ''

  build() {
    NavDestination() {
      Column({ space: 15 }) {
        TextInput({
          placeholder: '请输入验证码',
        })
          .onChange((v: string) => {
            this.code = v
          })

          .width('80%')

        Button('登录').onClick((event: ClickEvent) => {
          if (!this.code) {
            promptAction.showToast({ message: '请输入验证码' })
            return
          }
          AppStorage.setOrCreate('isLogin', true)
          ZRouter.getInstance().removeByName(RouterConstants.LOGIN_PAGE)
          if (!ZRouter.getInstance().finishWithResult(true)) {
            ZRouter.getInstance().pop()
          }


        })
      }
      .justifyContent(FlexAlign.Start)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .title('LoginVerifyCodePage')
  }
}