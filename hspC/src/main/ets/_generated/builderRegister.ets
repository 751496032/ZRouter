
import { Index } from "../pages/Index";
import { Page1 } from "../pages/Page1";
import { Page2 } from "../pages/Page2";

@Builder
export function hspCIndexBuilder(name: string, param?: Object) {
  Index()
}
@Builder
export function hspCPage1Builder(name: string, param?: Object) {
  Page1()
}
@Builder
export function hspCPage2Builder(name: string, param?: Object) {
  Page2()
}
