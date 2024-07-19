
import { MainPage } from "../components/MainPage";
import { Page1 } from "../components/Page1";
import { Page2 } from "../components/Page2";

@Builder
export function harBMainPageBuilder(name: string, param?: Object) {
  MainPage()
}
@Builder
export function harBPage1Builder(name: string, param?: Object) {
  Page1()
}
@Builder
export function harBPage2Builder(name: string, param?: Object) {
  Page2()
}
