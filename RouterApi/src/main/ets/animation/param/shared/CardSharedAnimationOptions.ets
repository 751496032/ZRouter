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
  p: CardSharedAnimationProperties
  _navBgColor: ResourceColor | undefined
  _IsAdaptImmersive: boolean = false

  constructor(
    longTakeAnimationProperties: CardSharedAnimationProperties,
    bgColor: ResourceColor | undefined,
    isAdaptImmersive: boolean
  ) {
    this.p = longTakeAnimationProperties
    this._navBgColor = bgColor
    this._IsAdaptImmersive = isAdaptImmersive
  }

  updateModifier(modifier: NavAnimationModifier, isStart: boolean, status: NavAnimateStatus): void {
    if (!modifier.attribute
      || !this.p.stack1Modifier.attribute
      || !this.p.stack2Modifier.attribute
      || !this.p.stack3Modifier.attribute
      || !this.p.imageModifier.attribute
    ) {
      return
    }
    switch (status) {
      case NavAnimateStatus.PUSH_ENTER:
        if (!this._isBeforePage) {
          if (isStart) {
            this.p.initParams(this._IsAdaptImmersive);
            modifier.attribute.backgroundColor(Color.Transparent)
            this.p.stack1Modifier.attribute
              .scale({
                x: this.p.initScale,
                y: this.p.initScale
              })
              .translate({
                x: this.p.initTranslateX,
                y: this.p.initTranslateY,
              })
              .width(this.p.initClipWidth)
              .height(this.p.initClipHeight)
              .borderRadius(34)
            this.p.stack2Modifier.attribute
              .position({
                x: this.p.initPositionValueX,
                y: this.p.initPositionValueY
              })
            this.p.imageModifier.attribute
              .size(this.p.snapShotSize)
              .position({
                x: this.p.snapShotPositionX,
                y: this.p.snapShotPositionY
              })
            this.p.imageModifier.attribute.opacity(1.0)
            animateTo({
              delay: 50,
              duration: 200,
              curve: Curve.Sharp
            }, () => {
              this.p.imageModifier.attribute?.opacity(0.0)
            });
            this.p.stack3Modifier.attribute.opacity(0.0)
            animateTo({
              duration: 200,
              curve: Curve.Sharp
            }, () => {
              this.p.stack3Modifier.attribute?.opacity(1.0)
            });
          } else {
            modifier.attribute.backgroundColor(this._navBgColor ?? Color.White)
            this.p.stack1Modifier.attribute
              .scale({
                x: 1.0,
                y: 1.0
              })
              .translate({
                x: 0,
                y: 0
              })
              .width('100%')
              .height('100%')
              .borderRadius(0)
            this.p.stack2Modifier.attribute
              .position({
                x: 0,
                y: 0
              })
          }
        }
        break
      case NavAnimateStatus.POP_EXIT:
        if (!this._isBeforePage) {
          if (isStart) {
          } else {
            modifier.attribute.backgroundColor(Color.Transparent)
            this.p.stack1Modifier.attribute
              .scale({
                x: this.p.initScale,
                y: this.p.initScale
              })
              .translate({
                x: this.p.initTranslateX,
                y: this.p.initTranslateY
              })
              .width(this.p.initClipWidth)
              .height(this.p.initClipHeight)
              .borderRadius(16)
            this.p.stack2Modifier.attribute
              .position({
                x: this.p.initPositionValueX,
                y: this.p.initPositionValueY
              })
          }
        }
        break
    }
  }
}
 