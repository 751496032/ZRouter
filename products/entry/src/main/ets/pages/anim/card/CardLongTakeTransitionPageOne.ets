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

import { CardAttr, WaterFlowDataSource } from './WaterFlowDataSource';
import { Route, ZRouter } from 'routerapi';
import { RouterConstants } from '@hzw/common_library';
import { CardComponent } from './CardComponent';
import { getResourceString } from './ResourceString';


@Route({ name: RouterConstants.PAGE_CARD_ONE })
@Component
export struct CardLongTakeTransitionPageOne {
  @State dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  @State columnType: string = '';
  @StorageProp('currentBreakpoint') @Watch('upDateColumnData') currentBreakpoint: string = '';

  aboutToAppear(): void {
    for (let i = 0; i < 100; i++) {
      this.dataSource.pushData(new CardAttr());
    }
    this.upDateColumnData();
  }

  private upDateColumnData(): void {
    let currentBreakpoint: string | undefined = AppStorage.get('currentBreakpoint');
    if (currentBreakpoint === 'xs' || currentBreakpoint === 'sm') {
      this.columnType = '1fr 1fr';
    } else if (currentBreakpoint === 'md') {
      this.columnType = '1fr 1fr 1fr';
    } else {
      this.columnType = '1fr 1fr 1fr 1fr';
    }
  }

  private onColumnClicked(url: ResourceStr, id: string): void {
    ZRouter.animateMgr()
      .setNavigation(ZRouter.getInstance())
      .withSharedCardParams({
        imageRes: url,
        componentId: id,
      })
      .push(RouterConstants.PAGE_CARD_TWO)
  }

  build() {
    NavDestination() {
      Stack() {
        WaterFlow() {
          LazyForEach(this.dataSource, (item: CardAttr, index: number) => {
            FlowItem() {
              CardComponent({
                url: $r(`app.media.img_${(index % 6)}`),
                cardAttr: item,
                onColumnClicked: (url: ResourceStr) => {
                  this.onColumnClicked(url, `FlowItem_${index}`);
                }
              })
            }
            .width('100%')
            .borderRadius(10)
            .clip(true)
            .id(`FlowItem_${index}`)
          }, (item: string) => item)
        }
        .columnsTemplate(this.columnType)
        .columnsGap(10)
        .rowsGap(10)
        .width('100%')
        .height('100%')
      }
      .size({
        width: '100%',
        height: '100%'
      })
      .padding({
        left: 16,
        right: 16
      })
    }
    .backgroundColor('#F1F3F5')
    .title(getResourceString($r('app.string.card_title'), this))
    .onDisAppear(() => {
      ZRouter.animateMgr().unregisterAnim(this)
    })
    .attributeModifier(ZRouter.animateMgr().modifier(this))
  }
}