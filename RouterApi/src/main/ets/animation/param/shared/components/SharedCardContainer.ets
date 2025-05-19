import { ZRouter } from '../../../../api/Router';
import { CardSharedAnimationProperties } from '../CardSharedAnimationProperties';
import { SharedCardUtil } from '../utils/SharedCardUtil';

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
          Image(SharedCardUtil.getPixelMap())
            .size(this.properties.snapShotSize)
            .objectFit(ImageFit.Auto)
            .opacity(this.properties.snapShotOpacity)
            .syncLoad(true)// 显示前一页点击的卡片的截图
            .position({
              x: this.properties.snapShotPositionX,
              y: this.properties.snapShotPositionY
            })

          // 原始弹出页显示内容，添加透明度控制其动画显示。
          Stack() {
            this.content()
          }
          .size({
            width: '100%',
            height: '100%'
          })
          .opacity(this.properties.postPageOpacity)
        }
        .width('100%')
        .position({
          x: this.properties.positionXValue,
          y: this.properties.positionYValue
        })
      }
      .scale({
        x: this.properties.scaleValue,
        y: this.properties.scaleValue
      })
      .translate({
        x: this.properties.translateX,
        y: this.properties.translateY
      })
      .width(this.properties.clipWidth)
      .height(this.properties.clipHeight)
      .borderRadius(this.properties.radius)
      .expandSafeArea([SafeAreaType.SYSTEM])
      .clip(true)
      .backgroundColor(this.bgColor)
    }
  }
}