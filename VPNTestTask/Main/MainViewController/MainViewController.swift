
import UIKit

final class MainViewController: UIViewController {
  private var contentView: MainViewProtocol!
  
  private var menuItems: [MenuItem] = []
  private var categoryItems: [Category] = []
  private var isShowMenu: Bool = false
  private var timer: Timer?
  private var totalMinutes = 0
  
  init(contentView: MainViewProtocol) {
    self.contentView = contentView
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = contentView as? UIView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    contentView.updatePulseAnimateConnecView(connectionStatus: .disconnected)
  }
  
  private func setupUI() {
    setupMenuTableView()
    setupCategoryCollectionView()
    setupButtons()
  }
  
  private func setupMenuTableView() {
    menuItems = MenuItem.getMenuItem()
    contentView.menuContentView.menuTableView.delegate = self
    contentView.menuContentView.menuTableView.dataSource = self
    contentView.menuContentView.menuTableView.registerNibCell(ofType: MenuTableViewCell.self)
  }
  
  private func setupCategoryCollectionView() {
    categoryItems = Category.getCategory()
    contentView.categoryCollectionView.collectionViewLayout = setupCategoryCollectionViewFlowLayout()
    contentView.categoryCollectionView.delegate = self
    contentView.categoryCollectionView.dataSource = self
    contentView.categoryCollectionView.registerNibCell(ofType: CategoryCollectionViewCell.self)
  }
  
  private func setupCategoryCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = Constants.categoryLayoutMinimumLineSpacing
    layout.minimumInteritemSpacing = Constants.categoryLayoutMinimumInteritemSpacing
    return layout
  }
  
  private func setupButtons() {
    contentView.onMenuButton = { [weak self] in
      guard let sSelf = self else { return }
      if !sSelf.isShowMenu {
        sSelf.contentView.showMenu()
        sSelf.isShowMenu = true
      }
    }
    
    contentView.menuContentView.onMenuCloseButton = { [weak self] in
      guard let sSelf = self else { return }
      sSelf.contentView.hideMenu()
      sSelf.isShowMenu = false
    }
    
    contentView.onConnectionButton = { [weak self] conectionStatus in
      guard let sSelf = self else { return }
      switch conectionStatus {
      case .disconnected:
        sSelf.stopTimer()
        sSelf.contentView.updatePulseAnimateConnecView(connectionStatus: .disconnected)
        sSelf.contentView.connectionStatus = .connecting
        
      case .connecting:
        sSelf.contentView.updatePulseAnimateConnecView(connectionStatus: .connecting)
        sSelf.contentView.connectionStatus = .connected
        sSelf.contentView.connectPowerView.isUserInteractionEnabled = false
        sSelf.mockConnectVPN()
        
      case .connected:
        sSelf.updateTimerLabel()
        sSelf.startTimer()
        sSelf.contentView.updatePulseAnimateConnecView(connectionStatus: .connected)
        sSelf.contentView.connectionStatus = .disconnected
      }
    }
  }
  
  private func mockConnectVPN() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
      guard let sSelf = self else { return }
      sSelf.contentView.onConnectionButton?(sSelf.contentView.connectionStatus)
      sSelf.contentView.connectPowerView.isUserInteractionEnabled = true
    }
  }
  
  private func startTimer() {
    if timer == nil {
      timer = Timer.scheduledTimer(
        timeInterval: 1.0,
        target: self,
        selector: #selector(updatetotalMinutes),
        userInfo: nil,
        repeats: true
      )
    }
  }
  
  private func stopTimer() {
    timer?.invalidate()
    timer = nil
    totalMinutes = 0
    updateTimerLabel()
  }
  
  private func updateTimerLabel() {
    let hours = totalMinutes / 60
    let minutes = totalMinutes % 60
    contentView.updateTimerLabel(seconds: String(format: "%02d:%02d", hours, minutes))
  }
  
  @objc
  private func updatetotalMinutes() {
    totalMinutes += 1
    updateTimerLabel()
  }
}

// MARK: Menu UITableViewDataSource
extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableNibCell(of: MenuTableViewCell.self, forIndexPath: indexPath)
    if let menuCell = cell as? MenuTableViewCell {
      menuCell.setup(model: menuItems[indexPath.row])
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return Constants.defaultMenuCellHeight
  }
}

// MARK: Menu UITableViewDataSource
extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let indexPath = tableView.indexPathForSelectedRow {
      let currentCell = tableView.cellForRow(at: indexPath) as? MenuTableViewCell
      currentCell?.alpha = 0.5
      UIView.animate(withDuration: 1, animations: {
        currentCell?.alpha = 1
      })
    }
  }
}

// MARK: Category UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categoryItems.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableNibCell(of: CategoryCollectionViewCell.self, forIndexPath: indexPath)
    if let categoryCell = cell as? CategoryCollectionViewCell {
      categoryCell.setup(category: categoryItems[indexPath.row])
    }
    return cell
  }
}

// MARK: Category UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
  
}

// MARK: Category UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let minimumInteritemSpacing = Int(Constants.categoryLayoutMinimumInteritemSpacing)
    let itemWidth = (Int(collectionView.frame.width) - minimumInteritemSpacing * 2) / (categoryItems.count / 2)
    return CGSize(width: itemWidth, height: Constants.categoryDefaultHeightCell)
  }
}
