
import UIKit

final class MenuView: UIView {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var menuTableView: UITableView!
  
  var onMenuCloseButton: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("\(type(of: self))", owner: self, options: nil)
    
    addSubview(contentView)
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      contentView.topAnchor.constraint(equalTo: topAnchor),
      contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
      contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
      contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    setupUI()
  }
  
  private func setupUI() {
    contentView.backgroundColor = UIColor.ColorConstants.lightGray
  }
  
  @IBAction func menuCloseButtonTapped(_ sender: UIButton) {
    onMenuCloseButton?()
  }
}
