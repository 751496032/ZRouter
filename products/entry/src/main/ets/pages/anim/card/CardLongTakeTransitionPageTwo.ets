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
import { Route, SharedCardContainer, ZRouter } from 'routerapi';
import { CardComponent } from './CardComponent';
import { CardAttr, WaterFlowDataSource } from './WaterFlowDataSource';

@Builder
export function CardLongTakeTransitionPageTwoBuilder() {
  CardLongTakeTransitionPageTwo()
}

@Route({ name: RouterConstants.PAGE_CARD_TWO })
@Component
export struct CardLongTakeTransitionPageTwo {
  @State dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  @State flag: number = 0

  aboutToAppear(): void {
    for (let i = 0; i < 100; i++) {
      this.dataSource.pushData(new CardAttr());
    }
    this.flag = ZRouter.getInstance().getParamByKey("flag")
  }

  onBackPressed(): boolean {
    ZRouter.getInstance().pop()
    return true;
  }

  @Builder
  Content() {
    Scroll() {
      Column() {
        Row({ space: 10 }) {
          Image($r('app.media.icon_back'))
            .width(40)
            .height(40)
            .onClick(() => {
              this.onBackPressed();
            })
            .margin({ left: 20 })

          Text($r('app.string.page_show'))
            .height(56)
            .width('100%')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
        }
        .clip(true)
        .width('100%')
        .height(px2vp(182))
        .alignItems(VerticalAlign.Center)

        Image(ZRouter.animateMgr().sharedCard().getSharedUrl())
          .size({ width: '100%' })
          .objectFit(ImageFit.Auto)
          .id(ZRouter.animateMgr().sharedCard().getSharedComponentId())

        List() {
          LazyForEach(this.dataSource, (item: CardAttr, index: number) => {
            ListItem() {
              CardComponent({
                url: $r(`app.media.img_${(index % 6)}`),
                onColumnClicked: (url: ResourceStr) => {
                  ZRouter.animateMgr()
                    .setNavigation(ZRouter.getInstance().withParam("flag", this.flag+1))
                    .withSharedCardParams({
                      imageRes: url,
                      componentId: `FlowItem_${this.flag}_${index}`,
                    })
                    .push(RouterConstants.PAGE_CARD_TWO)
                }
              })
            }
            .borderRadius(10)
            .clip(true)
            .width(100)
            .id(`FlowItem_${this.flag}_${index}`)
          }, (item: string) => item)
        }
        .listDirection(Axis.Horizontal)
        .width('100%')
        .margin({ top: 1 })
      }
    }
  }

  build() {
    NavDestination() {
      SharedCardContainer({
        bgColor: Color.White,
        content: () => {
          this.Content()
        }
      })
    }
    .onReady((context: NavDestinationContext) => {
      ZRouter.animateMgr()
        .sharedCard()
        .setIsAdaptImmersive(false)
        .setNavBgColor(Color.White)
        .registerSharedCardAnimParam(this, context)
        .setEnterAnimate({ duration: 500 })
        .setExitAnimate({ duration: 500 })
    })
    .onDisAppear(() => {
      ZRouter.animateMgr().sharedCard().unregisterSharedCardAnim(this)
    })
    .hideTitleBar(true)
    .backgroundColor(Color.Transparent)
    .attributeModifier(ZRouter.animateMgr().modifier(this))
    .onBackPressed(() => {
      return this.onBackPressed();
    })
  }
}