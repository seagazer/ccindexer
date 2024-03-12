import { IndexerView } from '@seagazer/ccIndexer'

const DEFAULT_INDEX = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

@Entry
@Component
struct Index {
    @State selectedIndex: number = -1
    private scroller = new Scroller()
    private list = new Array<MockData>()

    aboutToAppear() {
        for (let i = 0; i < DEFAULT_INDEX.length; i++) {
            const groupId = DEFAULT_INDEX[i]
            let array = new Array<string>()
            for (let j = 0; j < 10; j++) {
                const data = groupId + " - mock data" + j
                array.push(data)
            }
            this.list.push(new MockData(groupId, array))
        }
    }

    @Builder
    listHeader(data: MockData) {
        Text(data.groupId)
            .fontColor(Color.Blue)
            .fontSize(32)
            .fontWeight(FontWeight.Bold)
            .width("100%")
            .height(56)
            .backgroundColor(Color.White)
    }

    build() {
        Row() {
            List({ scroller: this.scroller }) {
                ForEach(this.list, (data: MockData, index: number) => {
                    ListItemGroup({ header: this.listHeader(data) }) {
                        ForEach(data.dataList, (item: string, index: number) => {
                            ListItem() {
                                Text(item)
                                    .width("100%")
                                    .height(45)
                                    .fontSize(20)
                            }
                        })
                    }
                })
            }
            .scrollBar(BarState.Off)
            .layoutWeight(1)
            .height("100%")
            .sticky(StickyStyle.Header)
            .onScrollIndex((start) => {
                this.selectedIndex = start
            })

            IndexerView(
                {
                    indexArray: DEFAULT_INDEX,
                    selectedIndex: this.selectedIndex,
                    textSize: 12,
                    heightLightColor: "#ff419ee5",
                    normalColor: "#ffa0a0a0",
                    floatSelectedTextColor: "#ffffff",
                    floatSelectedViewColor: "#ff419ee5",
                    onIndexChanged: (index) => {
                        this.scroller.scrollToIndex(index)
                    }
                })
                .width(24)
                .height("60%")
        }
        .width('100%')
        .height('100%')
        .padding(16)
    }
}

class MockData {
    groupId: string
    dataList: Array<string>

    constructor(groupId: string, dataList: Array<string>) {
        this.groupId = groupId
        this.dataList = dataList
    }
}