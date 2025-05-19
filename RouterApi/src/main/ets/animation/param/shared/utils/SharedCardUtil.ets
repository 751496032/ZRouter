import { ZRouter } from '../../../../api/Router';
import { CardSharedAnimationProperties } from '../CardSharedAnimationProperties';
import { CardUtil } from './CardUtil';
import { SnapShotImage } from './SnapShotImage';
import { WindowUtils } from './WindowUtils';
import { image } from '@kit.ImageKit';

/**
 * @author: HHBin
 * @date: 2025/4/28
 * @desc:
 */
export class SharedCardUtil {

  public static getSharedUrl(): ResourceStr {
    let imageResource = ZRouter.getParamByKey('imageResource') as ResourceStr;
    return imageResource;
  }

  public static getSharedComponentId(): string | undefined {
    let prePageCardId = ZRouter.getParamByKey('clickedComponentId') as string;
    return CardUtil.getPostPageImageId(prePageCardId);
  }

  public static getPostPageImageId(prePageClickedCardId: string | undefined): string | undefined {
    return CardUtil.getPostPageImageId(prePageClickedCardId);
  }

  public static getWindowWidthPx(): number {
    return WindowUtils.windowWidth_px
  }

  public static getWindowHeightPx(): number {
    return WindowUtils.windowHeight_px
  }

  public static getTopAvoidAreaHeightPx(): number {
    return WindowUtils.topAvoidAreaHeight_px
  }

  public static getNavigationIndicatorHeightPx(): number {
    return WindowUtils.navigationIndicatorHeight_px
  }

  public static getPixelMap(): image.PixelMap | undefined {
    return SnapShotImage.pixelMap
  }
}