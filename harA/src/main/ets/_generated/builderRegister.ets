
import { LoginPage } from "../components/LoginPage";
import { LoginVerifyCodePage } from "../components/LoginVerifyCodePage";
import { MainPage } from "../components/MainPage";
import { Page1 } from "../components/Page1";
import { Page2 } from "../components/Page2";
import { Page3 } from "../components/Page3";
import { Page4 } from "../components/Page4";
import { Page5 } from "../components/Page5";

@Builder
export function harALoginPageBuilder() {
  LoginPage()
}
@Builder
export function harALoginVerifyCodePageBuilder() {
  LoginVerifyCodePage()
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
@Builder
export function harAPage3Builder() {
  Page3()
}
@Builder
export function harAPage4Builder() {
  Page4()
}
@Builder
export function harAPage5Builder() {
  Page5()
}
