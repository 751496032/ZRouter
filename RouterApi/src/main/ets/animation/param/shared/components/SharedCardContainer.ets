import { ZRouter } from '../../../../api/Router';
import { CardSharedAnimationProperties } from '../CardSharedAnimationProperties';

/**
 * @author: HHBin
 * @date: 2025/4/28
 * @desc:
 */
@Component
export struct SharedCardContainer {
  @State properties: CardSharedAnimationProperties | undefined = undefined;
  @Prop bgColor: ResourceColor = Color.White
  @BuilderParam content: () => void = this.builder

  aboutToAppear(): void {
    this.properties = ZRouter.animateMgr().getSharedCardAnimationProperties();
  }

  @Builder
  builder() {
  }

  build() {
    if (this.properties) {
      // Stack组件的alignContent设置为TopStart，否则在高度变化时，截图和内容会重新定位。
      Stack({ alignContent: Alignment.TopStart }) {
        Stack({ alignContent: Alignment.TopStart }) {
          // 显示前一页点击的卡片的截图
          Image(ZRouter.animateMgr().SharedCard().getPixelMap())
            .objectFit(ImageFit.Auto)
            .syncLoad(true)// 显示前一页点击的卡片的截图
            .attributeModifier(this.properties.imageModifier)

          // 原始弹出页显示内容，添加透明度控制其动画显示。
          Stack() {
            Column() {
              Column() {
                this.content()
              }
              .size({
                width: px2vp(ZRouter.animateMgr().SharedCard().getWindowWidthPx()),
                height: px2vp(ZRouter.animateMgr().SharedCard().getWindowHeightPx())
              })
            }
            .width('100%')
            .height('100%')
          }
          .size({
            width: '100%',
            height: '100%'
          })
          .attributeModifier(this.properties.stack3Modifier)
        }
        .width('100%')
        .attributeModifier(this.properties.stack2Modifier)
      }
      .clip(true)
      .backgroundColor(this.bgColor)
      .attributeModifier(this.properties.stack1Modifier)
    } else {
      this.content()
    }
  }
}