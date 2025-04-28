import NavAnimateStatus from '../../const/NavAnimateStatus';
import { NavAnimationModifier } from '../../modifier/NavAnimationModifier';
import { INavAnimateOptions } from '../INavAnimateOptions';
import { CardSharedAnimationProperties } from './CardSharedAnimationProperties';

/**
 * @author: HHBin
 * @date: 2025/4/28
 * @desc: 卡片一镜到底
 */

export class CardSharedAnimationOptions implements INavAnimateOptions {
  _isBeforePage: boolean = false;
  longTakeAnimationProperties: CardSharedAnimationProperties
  static readonly INIT_OVERLAY_COLOR = '#00000000';
  static readonly FINAL_OVERLAY_COLOR = '#33000000';

  constructor(longTakeAnimationProperties: CardSharedAnimationProperties) {
    this.longTakeAnimationProperties = longTakeAnimationProperties
  }

  updateModifier(modifier: NavAnimationModifier, isStart: boolean, status: NavAnimateStatus): void {
    switch (status) {
      case NavAnimateStatus.PUSH_ENTER:
        if (!this._isBeforePage) {
          if (isStart) {
            this.longTakeAnimationProperties.initParams();
            this.longTakeAnimationProperties.scaleValue = this.longTakeAnimationProperties.initScale;
            this.longTakeAnimationProperties.translateX = this.longTakeAnimationProperties.initTranslateX;
            this.longTakeAnimationProperties.clipWidth = this.longTakeAnimationProperties.initClipWidth;
            this.longTakeAnimationProperties.clipHeight = this.longTakeAnimationProperties.initClipHeight;
            this.longTakeAnimationProperties.translateY = this.longTakeAnimationProperties.initTranslateY;
            this.longTakeAnimationProperties.positionYValue = this.longTakeAnimationProperties.initPositionValueY;
            this.longTakeAnimationProperties.positionXValue = this.longTakeAnimationProperties.initPositionValueX;
            this.longTakeAnimationProperties.navDestinationBgColor = CardSharedAnimationOptions.INIT_OVERLAY_COLOR;
            modifier.attribute?.backgroundColor(this.longTakeAnimationProperties.navDestinationBgColor)
            animateTo({
              delay: 50,
              duration: 100,
              curve: Curve.Sharp
            }, () => {
              this.longTakeAnimationProperties.snapShotOpacity = 0;
            });

            animateTo({
              duration: 100,
              curve: Curve.Sharp
            }, () => {
              this.longTakeAnimationProperties.postPageOpacity = 1.0;
            });
          } else {
            this.longTakeAnimationProperties.scaleValue = 1.0;
            this.longTakeAnimationProperties.translateX = 0;
            this.longTakeAnimationProperties.translateY = 0;
            this.longTakeAnimationProperties.clipWidth = '100%';
            this.longTakeAnimationProperties.clipHeight = '100%';
            this.longTakeAnimationProperties.positionYValue = 0;
            this.longTakeAnimationProperties.positionXValue = 0;
            this.longTakeAnimationProperties.radius = 34;
            this.longTakeAnimationProperties.navDestinationBgColor = CardSharedAnimationOptions.FINAL_OVERLAY_COLOR;
            modifier.attribute?.backgroundColor(this.longTakeAnimationProperties.navDestinationBgColor)
          }
        }
        break
      case NavAnimateStatus.POP_EXIT:
        if (!this._isBeforePage) {
          if (isStart) {
          } else {
            this.longTakeAnimationProperties.scaleValue = this.longTakeAnimationProperties.initScale;
            this.longTakeAnimationProperties.translateX = this.longTakeAnimationProperties.initTranslateX;
            this.longTakeAnimationProperties.clipWidth = this.longTakeAnimationProperties.initClipWidth;
            this.longTakeAnimationProperties.clipHeight = this.longTakeAnimationProperties.initClipHeight;
            this.longTakeAnimationProperties.translateY = this.longTakeAnimationProperties.initTranslateY;
            this.longTakeAnimationProperties.radius = 16;
            this.longTakeAnimationProperties.positionXValue = this.longTakeAnimationProperties.initPositionValueX;
            this.longTakeAnimationProperties.positionYValue = this.longTakeAnimationProperties.initPositionValueY;
            this.longTakeAnimationProperties.navDestinationBgColor = CardSharedAnimationOptions.INIT_OVERLAY_COLOR;
            modifier.attribute?.backgroundColor(this.longTakeAnimationProperties.navDestinationBgColor)
          }
        }
        break
    }
  }
}
 