/**
 * @author: HZWei
 * @date: 2024/11/12
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library'
import { AttributeUpdater, NavDestinationModifier } from '@kit.ArkUI'
import { ZAttribute, ZAttributeModifier } from 'routerapi'


@Observed
@ZAttribute({ name: RouterConstants.CUSTOM_COMPONENT_VIEW })
export class NavDesModifier extends ZAttributeModifier {


  initializeModifier(instance: NavDestinationModifier): void {
    console.log("AttributeUpdater initializeModifier")
    instance.hideTitleBar(false)
  }



}
