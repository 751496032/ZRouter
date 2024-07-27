
import { Index } from "../pages/Index";
import { Page1 } from "../pages/Page1";
import { Page2 } from "../pages/Page2";

@Builder
export function hspCIndexBuilder() {
  Index()
}
@Builder
export function hspCPage1Builder() {
  Page1()
}
@Builder
export function hspCPage2Builder() {
  Page2()
}
