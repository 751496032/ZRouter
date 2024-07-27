
import { LoginPage } from "../components/LoginPage";
import { MainPage } from "../components/MainPage";
import { Page1 } from "../components/Page1";
import { Page2 } from "../components/Page2";

@Builder
export function harALoginPageBuilder() {
  LoginPage()
}
@Builder
export function harAMainPageBuilder() {
  MainPage()
}
@Builder
export function harAPage1Builder() {
  Page1()
}
@Builder
export function harAPage2Builder() {
  Page2()
}
