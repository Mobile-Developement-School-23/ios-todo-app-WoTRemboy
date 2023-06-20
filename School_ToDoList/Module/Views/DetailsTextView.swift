import UIKit

class DetailsTextView: UITextView {
    
    let placeholder = "Что надо сделать?"
    
    private func textViewInit() {
        text = placeholder
        textColor = UIColor(named: "LabelTertiary")
        font = .body()
        
        backgroundColor = UIColor(named: "BackSecondary")
        layer.cornerRadius = 16
        
        textContainerInset = UIEdgeInsets(top: 17, left: 10, bottom: 12, right: 16)
        contentInsetAdjustmentBehavior = .automatic
        textAlignment = .left
        
        isScrollEnabled = false
        isEditable = true
    }
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        textViewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textViewInit()
    }
    
}
