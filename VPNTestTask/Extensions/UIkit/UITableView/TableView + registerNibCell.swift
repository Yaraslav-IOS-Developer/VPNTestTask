
import UIKit

extension UITableView {
  func registerNibCell<CellType: UITableViewCell>(ofType type: CellType.Type) {
    let nibName = String(describing: type)
    let nib = UINib(nibName: nibName, bundle: nil)
    register(nib, forCellReuseIdentifier: nibName)
  }
  
  func dequeueReusableNibCell<CellType: UITableViewCell>(of type: CellType.Type, forIndexPath indexPath: IndexPath) -> UITableViewCell {
    let identifier = String(describing: type)
    return dequeueReusableCell(withIdentifier: identifier, for: indexPath)
  }
}

extension UITableView {
  func deleteSwipeAction(backgroundColor: UIColor, icon: UIImage?, completion: (() -> Void)?) -> UIContextualAction {
    let action = UIContextualAction(style: .destructive, title: nil, handler: { (action, view, compl) in
      completion?()
    })

    action.backgroundColor = backgroundColor
    action.image = icon
    return action
  }
}
