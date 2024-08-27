import { Route, ZRouter } from 'routerapi'

/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */


@Route({ name: 'LoginPage'})
@Component
export struct LoginPage{

  build() {
    NavDestination(){
       Column({space:15}){
         Button('填写登录验证码').onClick((event: ClickEvent) => {
           ZRouter.push("loginVerifyCodePage")
         })

         Button('登录成功').onClick((event: ClickEvent) => {
           AppStorage.setOrCreate<boolean>('isLogin', true)
           ZRouter.finishWithResult<boolean>(true)
         })
       }
       .width('100%')
       .height('100%')
    }
      .width('100%')
      .height('100%')
      .title('LoginPage')
  }
}