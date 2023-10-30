
import UIKit

final class MenuTableViewCell: UITableViewCell {
  @IBOutlet weak var iconImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  
  func setup(model: MenuItem) {
    iconImageView.image = UIImage(named: model.imageName)
    titleLabel.text = model.title
  }
}
