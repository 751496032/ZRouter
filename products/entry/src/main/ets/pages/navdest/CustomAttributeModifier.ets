/**
 * @author: HZWei
 * @date: 2024/11/12
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library'
import { AttributeUpdater, NavDestinationModifier } from '@kit.ArkUI'
import { ZAttribute, ZAttributeModifier } from 'routerapi'


@ZAttribute({ name: RouterConstants.CUSTOM_COMPONENT_CHILD_VIEW })
export class CustomAttributeModifier extends ZAttributeModifier {
  counter = 0
  initModifier(instance: NavDestinationModifier): void {
    instance.hideTitleBar(false)
    instance.mode(NavDestinationMode.STANDARD)
  }




}
