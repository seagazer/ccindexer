/**
 * A custom indexer view with motion animation.
 */
@Component
export struct IndexerView {
    /**
     * The index data of the indexer view.
     */
    @Prop indexArray: Array<string>
    /**
     * The size of the char text.
     */
    @Prop textSize: number
    /**
     * The value to observe the selected index.
     */
    @Prop selectedIndex: number
    @State isPressed: boolean = false
    @State charWidth: number = 0
    @State charHeight: number = 0
    private viewHeight: number = 0
    /* ------------------ heightLight style  ------------------*/
    /**
     * The color of current selected index.
     */
    heightLightColor: ResourceColor = "#000000"
    /**
     * The color of unselected index.
     */
    normalColor: ResourceColor = "#ff737373"
    /* ------------------ float selected view style  ------------------*/
    /**
     * Display the float selected view or not.
     */
    isShowFloatSelectedView: boolean = true
    /**
     * The size of float selected view.
     */
    floatSelectedViewSize: number = 32
    /**
     * The color of float selected view text.
     */
    floatSelectedTextColor: ResourceColor = "#ffffff"
    /**
     * The color of float selected view background.
     */
    floatSelectedViewColor: ResourceColor = "#000000"
    /* ------------------ animation style  ------------------*/
    /**
     * The duration of animation for this view.
     */
    animationDuration: number = 300
    /**
     * The translation size of animation.
     */
    animationTranslation: number = 32
    /**
     * The observe to watch the index changed by user.
     */
    onIndexChanged: ((index: number) => void) | null = null

    build() {
        Stack() {
            // anchor
            Column() {
                ForEach(this.indexArray, (char: string, index: number) => {
                    Text(char)
                        .fontSize(this.textSize)
                        .fontColor(this.selectedIndex == index ? this.heightLightColor : this.normalColor)
                        .fontWeight(this.selectedIndex == index ? FontWeight.Bold : FontWeight.Normal)
                        .textAlign(TextAlign.Center)
                        .width("100%")
                        .height(this.charHeight)
                        .translate({
                            x: this.selectedIndex == index && this.isPressed ? -this.animationTranslation :
                                this.selectedIndex == index + 1 && this.isPressed || this.selectedIndex == index - 1 && this.isPressed ? -this.animationTranslation * 0.75 :
                                    this.selectedIndex == index + 2 && this.isPressed || this.selectedIndex == index - 2 && this.isPressed ? -this.animationTranslation * 0.5 :
                                        this.selectedIndex == index + 3 && this.isPressed || this.selectedIndex == index - 3 && this.isPressed ? -this.animationTranslation * 0.25 : 0
                        })
                        .animation({
                            duration: this.animationDuration
                        })
                })
            }
            .width("100%")
            .height("100%")

            // float selected view
            if (this.isShowFloatSelectedView) {
                Text(this.indexArray[this.selectedIndex])
                    .fontColor(this.floatSelectedTextColor)
                    .textAlign(TextAlign.Center)
                    .fontSize(this.floatSelectedViewSize * 0.6)
                    .width(this.floatSelectedViewSize)
                    .height(this.floatSelectedViewSize)
                    .border({ radius: this.floatSelectedViewSize })
                    .visibility(this.isPressed && this.selectedIndex >= 0 && this.selectedIndex <= this.indexArray.length - 1 ? Visibility.Visible : Visibility.Hidden)
                    .backgroundColor(this.floatSelectedViewColor)
                    .position({
                        x: -this.animationTranslation - this.floatSelectedViewSize * 1.2,
                        y: this.selectedIndex * this.charHeight - (this.floatSelectedViewSize - this.charHeight) * 0.5
                    })
                    .animation({
                        duration: this.animationDuration
                    })
            }
        }
        .align(Alignment.TopStart)
        .onAreaChange((_, newSize) => {
            this.charWidth = newSize.width as number
            this.viewHeight = newSize.height as number
            this.charHeight = this.viewHeight / this.indexArray.length
        })
        .onTouch((event) => {
            let motionEvent = event.touches[0]
            switch (motionEvent.type) {
                case TouchType.Down:
                case TouchType.Move:
                    this.isPressed = true
                    let currentY = motionEvent.y
                    if (currentY <= 0) {
                        this.selectedIndex = 0
                    } else if (currentY > this.viewHeight) {
                        this.selectedIndex = this.indexArray.length - 1
                    } else {
                        this.selectedIndex = Math.round(currentY / this.charHeight)
                    }
                    this.onIndexChanged?.(this.selectedIndex)
                    break
                case TouchType.Up:
                case TouchType.Cancel:
                    this.isPressed = false
                    break
                default:
                    break
            }
        })
    }
}