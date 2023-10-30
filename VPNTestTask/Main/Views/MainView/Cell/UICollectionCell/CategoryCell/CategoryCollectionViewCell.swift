import UIKit

final class CategoryCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  private func setupUI() {
    containerView.layer.cornerRadius = 28
    containerView.backgroundColor = UIColor.ColorConstants.lightGray
  }
  
  func setup(category: Category) {
    iconImage.image = UIImage(named: category.icon)
    titleLabel.text = category.title
  }
}
