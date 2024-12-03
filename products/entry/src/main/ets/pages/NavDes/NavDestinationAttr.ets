/**
 * @author: HZWei
 * @date: 2024/11/12
 * @desc:
 */
import { AttributeUpdater, NavDestinationModifier } from '@kit.ArkUI'
import { ZAttribute, ZAttributeModifier } from 'routerapi'


@Observed
@ZAttribute({ name: '' })
export class NavDesModifier extends ZAttributeModifier {


  initializeModifier(instance: NavDestinationModifier): void {
    console.log("AttributeUpdater initializeModifier")
    instance.hideTitleBar(false)
  }



}
