/**
 * @author: HZWei
 * @date: 2025/8/16
 * @desc:
 */
import { UIView } from "@hzw/common_library"

@Builder
export function BannerBuilder($$: UIView<string>) {
  Banner({ items: $$.data })
}

@Component
struct Banner {
  items: string[] = ['1', '2', '3', '4', '5']

  build() {
    Stack(){
      Swiper(){
        ForEach(this.items, (item: string, index: number) => {
          Column(){
            Text(item)
              .fontColor(Color.White)
              .fontSize(20)
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(Color.Red)
          .width('95%')
          .height(150)
        })
      }
      .autoPlay(true)
    }
  }
}