
import UIKit
import Lottie

protocol MainViewProtocol: AnyObject {
  var contentView: UIView! { get set }
  var menuContentView: MenuView! { get set }
  var menuButton: UIButton! { get set }
  var mainContetView: UIView! { get set }
  var mainBackgroundImageView: UIImageView! { get set }
  var connectPowerView: UIView! { get set }
  var connectionStatus: ConnectionStatus { get set }
  var categoryCollectionView: UICollectionView! { get set }
  var onMenuButton: (() -> Void)? { get set }
  var onConnectionButton: ((ConnectionStatus) -> Void)? { get set }
  func updateTimerLabel(seconds: String)
  func updatePulseAnimateConnecView(connectionStatus: ConnectionStatus)
  func showMenu()
  func hideMenu()
}

final class MainView: UIView, MainViewProtocol {
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var menuButton: UIButton!
  @IBOutlet weak var menuContentView: MenuView!
  @IBOutlet weak var mainContetView: UIView!
  @IBOutlet weak var mainBackgroundImageView: UIImageView!
  @IBOutlet weak var containerImageAndLabelConnectionView: UIVisualEffectView!
  @IBOutlet weak var connectionImageView: UIImageView!
  @IBOutlet weak var connectionLabel: UILabel!
  @IBOutlet weak var connectPowerView: UIView!
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var connectPowerImage: UIImageView!
  @IBOutlet weak var containerConnectPowerImageAndTimerStackView: UIStackView!
  @IBOutlet weak var containerLoadingAnimationView: UIView!
  @IBOutlet weak var categoryCollectionView: UICollectionView!
  
  private var defaultMainViewTransform = CGAffineTransform()
  private let screen = UIScreen.main.bounds
  private let animationView = LottieAnimationView(name: "main_loading_animation")
  var connectionStatus: ConnectionStatus = .connecting
  
  var onMenuButton: (() -> Void)?
  var onConnectionButton: ((ConnectionStatus) -> Void)?
  
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
    setupConnecView()
    setuAnimationView()
    contentView.backgroundColor = UIColor.ColorConstants.lightGray
    defaultMainViewTransform = mainContetView.transform
  }
  
  private func setupConnecView() {
    containerImageAndLabelConnectionView.layer.cornerRadius = 24
    containerImageAndLabelConnectionView.clipsToBounds = true
    connectPowerView.layer.cornerRadius = connectPowerView.layer.bounds.width / 2
    connectPowerView.backgroundColor = UIColor.ColorConstants.customBlue
    connectPowerImage.image = UIImage(named: "Main_Power")
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(connectViewTapped))
    connectPowerView.addGestureRecognizer(tapGesture)
  }
  
  private func createPulseAnimations(color: UIColor, pulseCount: Int, maxRadius: CGFloat, animationDuration: TimeInterval) {
    for index in 1...pulseCount {
      let radius = maxRadius - CGFloat(index - 1) * 20
      let pulse = PulseAnimation(numberOfPulse: Float.infinity, radius: radius, postion: connectPowerView.center)
      pulse.animationDuration = animationDuration
      pulse.backgroundColor = color.cgColor
      self.mainBackgroundImageView.layer.addSublayer(pulse)
    }
  }
  
  private func removePulseAnimations() {
    if let sublayers = mainBackgroundImageView.layer.sublayers {
      for sublayer in sublayers {
        sublayer.removeAllAnimations()
        sublayer.removeFromSuperlayer()
      }
    }
  }
  
  private func updateConnectionImageAndLabel(connectionStatus: ConnectionStatus) {
    switch connectionStatus {
    case .disconnected:
      connectionLabel.textColor = UIColor.black
    case .connecting:
      connectionLabel.textColor = UIColor.ColorConstants.customYellow
    case .connected:
      connectionLabel.textColor = UIColor.ColorConstants.customGreen
    }
    connectionLabel.text = connectionStatus.title
    connectionImageView.image = UIImage(named: connectionStatus.icon)
  }
  
  private func setuAnimationView() {
    containerLoadingAnimationView.addSubview(animationView)
    animationView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      animationView.topAnchor.constraint(equalTo: containerLoadingAnimationView.topAnchor),
      animationView.trailingAnchor.constraint(equalTo: containerLoadingAnimationView.trailingAnchor),
      animationView.leadingAnchor.constraint(equalTo: containerLoadingAnimationView.leadingAnchor),
      animationView.bottomAnchor.constraint(equalTo: containerLoadingAnimationView.bottomAnchor)
    ])
  }
  
  private func updateContainerConnectPowerImageAndTimerStackView(connectionStatus: ConnectionStatus) {
    switch connectionStatus {
    case .disconnected:
      containerConnectPowerImageAndTimerStackView.isHidden = false
      containerLoadingAnimationView.isHidden = true
      timerLabel.isHidden = true
    case .connecting:
      containerConnectPowerImageAndTimerStackView.isHidden = true
      containerLoadingAnimationView.isHidden = false
    case .connected:
      containerLoadingAnimationView.isHidden = true
      containerConnectPowerImageAndTimerStackView.isHidden = false
      timerLabel.isHidden = false
    }
  }
  
  private func startAnimation() {
    animationView.play()
    animationView.loopMode = .loop
  }
  
  func updatePulseAnimateConnecView(connectionStatus: ConnectionStatus) {
    switch connectionStatus {
    case .disconnected:
      removePulseAnimations()
      createPulseAnimations(
        color: UIColor.ColorConstants.customBlue,
        pulseCount: Constants.pulseCount,
        maxRadius: Constants.maxRadius,
        animationDuration: Constants.animationDurationForPulseButton
      )
      connectPowerView.backgroundColor = UIColor.ColorConstants.customBlue
      
    case .connecting:
      removePulseAnimations()
      createPulseAnimations(
        color: UIColor.ColorConstants.customYellow,
        pulseCount: Constants.pulseCount,
        maxRadius: Constants.maxRadius,
        animationDuration: Constants.animationDurationForPulseButton
      )
      connectPowerView.backgroundColor = UIColor.ColorConstants.customYellow
      startAnimation()
      
    case .connected:
      removePulseAnimations()
      createPulseAnimations(
        color: UIColor.ColorConstants.customGreen,
        pulseCount: Constants.pulseCount,
        maxRadius: Constants.maxRadius,
        animationDuration: Constants.animationDurationForPulseButton
      )
      connectPowerView.backgroundColor = UIColor.ColorConstants.customGreen
    }
    updateConnectionImageAndLabel(connectionStatus: connectionStatus)
    updateContainerConnectPowerImageAndTimerStackView(connectionStatus: connectionStatus)
  }
  
  func updateTimerLabel(seconds: String) {
    timerLabel.text = seconds
  }
  
  func showMenu() {
    mainContetView.layer.cornerRadius = Constants.cornerRadius
    mainBackgroundImageView.layer.cornerRadius = mainContetView.layer.cornerRadius
    let x = screen.width * Constants.xMultiplier
    
    let originalTransform = self.mainContetView.transform
    let scaledTransform = originalTransform.scaledBy(x: Constants.scale, y: Constants.scale)
    let scaledAndTranslatedTransform = scaledTransform.translatedBy(x: x, y: 0)
    UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
      guard let sSelf = self else { return }
      let rotatedTransform = scaledAndTranslatedTransform.rotated(by: Constants.rotationAngle)
      sSelf.mainContetView.transform = rotatedTransform
    })
  }
  
  func hideMenu() {
    UIView.animate(withDuration: Constants.animationDuration, animations: { [weak self] in
      guard let sSelf = self else { return }
      sSelf.mainContetView.transform = sSelf.defaultMainViewTransform
      sSelf.mainContetView.layer.cornerRadius = Constants.resetCornerRadius
      sSelf.mainBackgroundImageView.layer.cornerRadius = Constants.resetCornerRadius
    })
  }
  
  @objc
  func connectViewTapped() {
    onConnectionButton?(connectionStatus)
  }
  
  @IBAction func menuButtonTapped(_ sender: UIButton) {
    onMenuButton?()
  }
}
