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
import { Route, ZRouter } from 'routerapi';
import { CardUtil } from './CardUtil';
import { DetailPageContent } from './DetailPageContent';
import { LongTakeAnimationProperties } from './LongTakeAnimationProperties';
import { SnapShotImage } from './SnapShotImage';

@Builder
export function CardLongTakeTransitionPageTwoBuilder() {
  CardLongTakeTransitionPageTwo()
}

@Route({ name: RouterConstants.PAGE_CARD_TWO })
@Component
export struct CardLongTakeTransitionPageTwo {
  @State longTakeAnimationProperties: LongTakeAnimationProperties = new LongTakeAnimationProperties();
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
      // Stack needs to set the alignContent to TopStart, otherwise the screenshot and content will be repositioned with the height as it changes.
      Stack({ alignContent: Alignment.TopStart }) {
        Stack({ alignContent: Alignment.TopStart }) {
          // Used to display a screenshot of the card clicked on the previous page.
          Image(this.snapShotImage)
            .size(this.longTakeAnimationProperties.snapShotSize)
            .objectFit(ImageFit.Auto)
            .opacity(this.longTakeAnimationProperties.snapShotOpacity)// eslint-disable-next-line @performance/hp-arkui-image-async-load
            .syncLoad(true)// The position here gives the distance from the screenshot position to the expanded page image position.
            .position({
              x: this.longTakeAnimationProperties.snapShotPositionX,
              y: this.longTakeAnimationProperties.snapShotPositionY
            })

          // The pop-up page originally displays the content, adding transparency to control its display during animation.
          DetailPageContent({
            indexValue: this.indexValue,
            onBackPressed: () => {
              this.onBackPressed()
            },
            SharedComponentId: CardUtil.getPostPageImageId(this.clickedCardId)
          })
            .size({
              width: '100%',
              height: '100%'
            })
            .opacity(this.longTakeAnimationProperties.postPageOpacity)
        }
        .width('100%')
        .position({
          x: this.longTakeAnimationProperties.positionXValue,
          y: this.longTakeAnimationProperties.positionYValue
        })
      }
      .scale({
        x: this.longTakeAnimationProperties.scaleValue,
        y: this.longTakeAnimationProperties.scaleValue
      })
      .translate({
        x: this.longTakeAnimationProperties.translateX,
        y: this.longTakeAnimationProperties.translateY
      })
      .width(this.longTakeAnimationProperties.clipWidth)
      .height(this.longTakeAnimationProperties.clipHeight)
      .borderRadius(this.longTakeAnimationProperties.radius)
      .expandSafeArea([SafeAreaType.SYSTEM])
      .backgroundColor($r('app.color.water_flow_background_color'))
      .clip(true)
    }
    .backgroundColor(this.longTakeAnimationProperties.navDestinationBgColor)
    .hideTitleBar(true)
    .onReady((context: NavDestinationContext) => {
      let clickedCardId = ZRouter.getParamByKey('clickedComponentId') as string;
      this.indexValue = ZRouter.getParamByKey('indexValue') as number;
      this.prePageDoFinishTransition = ZRouter.getParamByKey('doDefaultTransition') as () => void;
      if (context.navDestinationId && clickedCardId) {
        this.pageId = context.navDestinationId;
        this.clickedCardId = clickedCardId;
        this.longTakeAnimationProperties.init(clickedCardId, this.prePageDoFinishTransition)
        this.longTakeAnimationProperties.doAnimation(this, context)
      }
    })
    .onDisAppear(() => {
      ZRouter.getInstance().animateMgr().unregisterAnim(this)
    })
    .attributeModifier(ZRouter.getInstance().animateMgr().modifier(this))
    .onBackPressed(() => {
      return this.onBackPressed();
    })
  }
}