/**
 * @author: HZWei
 * @date: 2025/5/24
 * @desc:
 */

@ComponentV2
export struct BottomNavigationBar {
  @Param @Require currentIndex: number = 0;
  @Event private $currentIndex: (index: number) => void = (index) => {
  }
  @Param onItemClick?: (index: number) => boolean | void = (index) => {

  }
  private tabList = [
    '首页', '动画', '我的'
  ]

  build() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center,
    }) {
      ForEach(this.tabList, (item: string, index) => {
        this.tabBuilder(item, index)
      })
    }.width('100%')
    .height(50)
    .shadow({
      color: "#E5E5E5",
      radius: 3,
      offsetY: -1
    })
  }

  @Builder
  tabBuilder(title: string, targetIndex: number, selectedImg?: Resource, normalImg?: Resource) {
    Column() {
      if (selectedImg) {
        Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
          .size({ width: 25, height: 25 })
      }
      Text(title)
        .fontWeight(this.currentIndex === targetIndex ? FontWeight.Bold : FontWeight.Normal)
        .fontColor(this.currentIndex === targetIndex ? Color.Blue : '#6B6B6B')
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      if (this.onItemClick) {
        const r = this.onItemClick(targetIndex)
        if (typeof r === 'boolean' && r) {
        } else {
          this.$currentIndex(targetIndex)
        }
      } else {
        this.$currentIndex(targetIndex)
      }

    })
  }
}