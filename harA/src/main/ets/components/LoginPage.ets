/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
import { Route } from 'routerapi/src/main/ets/annotation/Route';
import { ZRouter } from 'routerapi/src/main/ets/api/Router';

@Route({ name: 'LoginPage'})
@Component
export struct LoginPage{

  build() {
    NavDestination(){
       Column({space:15}){
         Button('登录成功').onClick((event: ClickEvent) => {
           AppStorage.setOrCreate('isLogin', true)
           ZRouter.popWithResult("login success")
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