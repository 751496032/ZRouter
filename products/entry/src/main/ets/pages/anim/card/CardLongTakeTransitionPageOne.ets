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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { componentSnapshot } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { CardAttr, WaterFlowDataSource } from './WaterFlowDataSource';
import { SnapShotImage } from './SnapShotImage';
import { Route, SharedCardUtil, ZRouter } from 'routerapi';
import { RouterConstants } from '@hzw/common_library';
import { CardComponent } from './CardComponent';
import { getResourceString } from './ResourceString';


@Route({ name: RouterConstants.PAGE_CARD_ONE })
@Component
export struct CardLongTakeTransitionPageOne {
  @State dataSource: WaterFlowDataSource = new WaterFlowDataSource();
  @State columnType: string = '';
  @StorageProp('currentBreakpoint') @Watch('upDateColumnData') currentBreakpoint: string = '';
  private clickedIndex: number = -1;

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

  private doFinishTransition(): void {
    this.dataSource.getData(this.clickedIndex).isVisible = Visibility.Visible;
  }

  private onColumnClicked(indexValue: string): void {
    let clickedIndex = parseInt(indexValue);
    this.clickedIndex = clickedIndex;
    // Click the card to get the corresponding screenshot and save it.
    componentSnapshot.get('FlowItem_' + indexValue, (error: Error, pixelMap: image.PixelMap) => {
      if (error) {
        hilog.info(0x0000, 'CardLongTakePageOne', 'componentSnapshot.get error, reason: ' + JSON.stringify(error));
        // If the screenshot fails, go to the default left/right transition. In this case, the pop-up page will not receive clickedComponentId parameter, and the registration process will not proceed.
        // At that time from and to the animation are undefined, will go in customNavContentTransition transitions by default.
        ZRouter.getInstance()
          .withParam('indexValue', clickedIndex)
          .push(RouterConstants.PAGE_CARD_TWO)
        return;
      } else {
        hilog.info(0x0000, 'CardLongTakePageOne', 'componentSnapshot.get success!');
        // If the screenshot is successful, then go to a custom mirror in the end transition.
        SnapShotImage.pixelMap = pixelMap;
        ZRouter.getInstance()
          .withParam('indexValue', clickedIndex)
          .withParam('clickedComponentId', SharedCardUtil.getFlowItemIdByIndex(indexValue))
          .withParam('doDefaultTransition', () => {
            this.doFinishTransition();
          })
          .push(RouterConstants.PAGE_CARD_TWO)
        this.dataSource.getData(this.clickedIndex).isVisible = Visibility.Hidden;
      }
    })
  }

  build() {
    NavDestination() {
      Stack() {
        WaterFlow() {
          LazyForEach(this.dataSource, (item: CardAttr, index: number) => {
            FlowItem() {
              CardComponent({
                indexValue: index.toString(),
                cardAttr: item,
                onColumnClicked: (indexValue: string) => {
                  this.onColumnClicked(indexValue);
                }
              })
            }
            .width('100%')
            .borderRadius(10)
            .clip(true)
            .id(SharedCardUtil.getFlowItemIdByIndex(index.toString()))
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