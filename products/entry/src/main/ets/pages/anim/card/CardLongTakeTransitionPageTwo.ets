/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { RouterConstants } from '@hzw/common_library';
import { CardSharedAnimationProperties, Route, SharedCardUtil, ZRouter } from 'routerapi';
import { DetailPageContent } from './DetailPageContent';
import { SnapShotImage } from './SnapShotImage';

@Builder
export function CardLongTakeTransitionPageTwoBuilder() {
  CardLongTakeTransitionPageTwo()
}

@Route({ name: RouterConstants.PAGE_CARD_TWO })
@Component
export struct CardLongTakeTransitionPageTwo {
  @State properties: CardSharedAnimationProperties = SharedCardUtil.createSharedAnimationProperties();
  @StorageProp('windowSizeChanged') @Watch('unRegisterNavParam') windowSizeChangedTime: number = 0;
  @StorageProp('onConfigurationUpdate') @Watch('unRegisterNavParam') onConfigurationUpdateTime: number = 0;
  @State snapShotImage: PixelMap | undefined = SnapShotImage.pixelMap;
  private rectWidth: number = 0;
  private scaleValue: number = 0;
  private indexValue: number = -1;
  private pageId: string = '';
  private shouldDoDefaultTransition: boolean = false;
  private prePageDoFinishTransition: () => void = () => {
  };
  private clickedCardId: string | undefined = undefined;

  unRegisterNavParam(): void {
    this.shouldDoDefaultTransition = true;
  }

  onBackPressed(): boolean {
    // if (this.shouldDoDefaultTransition) {
    //   CustomTransition.getInstance().unRegisterNavParam(this.pageId);
    //   this.pageInfos.pop();
    //   this.prePageDoFinishTransition();
    //   this.shouldDoDefaultTransition = false;
    //   return true;
    // }
    ZRouter.getInstance().pop()
    return true;
  }

  build() {
    NavDestination() {
      // Stack组件的alignContent设置为TopStart，否则在高度变化时，截图和内容会重新定位。
      Stack({ alignContent: Alignment.TopStart }) {
        Stack({ alignContent: Alignment.TopStart }) {
          // 显示前一页点击的卡片的截图
          Image(this.snapShotImage)
            .size(this.properties.snapShotSize)
            .objectFit(ImageFit.Auto)
            .opacity(this.properties.snapShotOpacity)
            .syncLoad(true)// 显示前一页点击的卡片的截图
            .position({
              x: this.properties.snapShotPositionX,
              y: this.properties.snapShotPositionY
            })

          // 原始弹出页显示内容，添加透明度控制其动画显示。
          DetailPageContent({
            indexValue: this.indexValue,
            onBackPressed: () => {
              this.onBackPressed()
            },
            SharedComponentId: SharedCardUtil.getPostPageImageId(this.clickedCardId)
          })
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
      .backgroundColor($r('app.color.water_flow_background_color'))
      .clip(true)
    }
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      let clickedCardId = ZRouter.getParamByKey('clickedComponentId') as string;
      this.indexValue = ZRouter.getParamByKey('indexValue') as number;
      this.prePageDoFinishTransition = ZRouter.getParamByKey('doDefaultTransition') as () => void;
      if (context.navDestinationId && clickedCardId) {
        this.pageId = context.navDestinationId;
        this.clickedCardId = clickedCardId;
        this.properties.init(clickedCardId, this.prePageDoFinishTransition)
        this.properties.doAnimation(this, context)
      }
    })
    .onDisAppear(() => {
      ZRouter.animateMgr().unregisterAnim(this)
    })
    .backgroundColor(Color.Transparent)
    .attributeModifier(ZRouter.animateMgr().modifier(this))
    .onBackPressed(() => {
      return this.onBackPressed();
    })
  }
}