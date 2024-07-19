
import { LoginPage } from "../components/LoginPage";
import { MainPage } from "../components/MainPage";
import { Page1 } from "../components/Page1";
import { Page2 } from "../components/Page2";

@Builder
export function harALoginPageBuilder(name: string, param?: Object) {
  LoginPage()
}
@Builder
export function harAMainPageBuilder(name: string, param?: Object) {
  MainPage()
}
@Builder
export function harAPage1Builder(name: string, param?: Object) {
  Page1()
}
@Builder
export function harAPage2Builder(name: string, param?: Object) {
  Page2()
}
