/**
 * @author: HZWei
 * @date: 2025/3/4
 * @desc:
 */
import { RouterConstants } from '@hzw/common_library';
import { ZRoute, ZRouter } from 'routerapi';

const newTaskName = 'Nest';

@ZRoute({ name: RouterConstants.NEST_PAGE })
@Component
export struct NestPage {
  build() {
    NavDestination() {
      Column() {
        Column({ space: 20 }) {
          Text('默认Navigation栈名区')
            .fontColor(Color.White)
            .textAlign(TextAlign.Center)
            .width('100%')

          Button('返回 - 默认栈').onClick((event: ClickEvent) => {
            ZRouter.getInstance('ZRouter').pop()
          }).fontColor(Color.White)

          Button('返回').onClick((event: ClickEvent) => {
            ZRouter.getInstance().pop()
          }).fontColor(Color.White)

        }
        .width('100%')
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.Blue)
        .layoutWeight(1)

        Navigation(ZRouter.getNavStackByName(newTaskName)) {
          Column({ space: 20 }) {
            Text('嵌套Navigation栈名区')
              .textAlign(TextAlign.Center)
              .padding(30)
              .width('100%')

            Button('返回').onClick((event: ClickEvent) => {
              ZRouter.getInstance(newTaskName).pop()
            })



            Button('to NestChild1Page').onClick((event: ClickEvent) => {
              ZRouter.getInstance(newTaskName).navigation('NestChild1Page')
            })
          }.alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .layoutWeight(2)
      }
    }
  }
}

@ZRoute({ name: 'NestChild1Page' })
@Component
export struct NestChild1Page {
  build() {

    NavDestination() {
      Column({ space: 20 }) {
        Text('NestChild1Page')
          .padding(30)

        Button('返回').onClick((event: ClickEvent) => {
          ZRouter.getInstance(newTaskName).pop()
        })
        Button('to NestChild2Page').onClick((event: ClickEvent) => {
          ZRouter.getInstance(newTaskName).navigation('NestChild2Page')
        })
      }
    }
  }
}

@ZRoute({ name: 'NestChild2Page' })
@Component
export struct NestChild2Page {
  build() {
    NavDestination() {
      Column({ space: 20 }) {
        Text('NestChild2Page')
          .padding(30)

        Button('返回 指定栈名 newTaskName').onClick((event: ClickEvent) => {
          ZRouter.getInstance(newTaskName).pop()
        })

        Button('返回 指定栈名 默认').onClick((event: ClickEvent) => {
          ZRouter.getInstance('ZRouter').pop()
        })


      }
    }
  }
}