//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

enum BottomSheetViewState {
    case expand
    case collapse
}

open class BottomSheetViewController: UIViewController {
    private var animator: UIViewPropertyAnimator?
    private var contentViewController: UIViewController
    private var currentState: BottomSheetViewState = .collapse
    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        return view
    }()
    private lazy var gestureRecognizer: UIPanGestureRecognizer = {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(handlePan))
        return recognizer
    }()

    @objc public init(with contentViewController: UIViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
        addChild(contentViewController)
        contentViewController.didMove(toParent: self)
    }
    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    deinit {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }

    @objc private func handleOrientationChanged() {
        if currentState == .collapse {
            let windowFrame = self.view.window?.frame ?? .zero
            let windowWidth = windowFrame.width
            let windowHeight = windowFrame.height
            view.frame = CGRect(x: 0, y: windowHeight - 200, width: windowWidth, height: 200)
             view.layoutIfNeeded();
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.NavigationBar.background

        view.layer.shadowColor = Constants.Shadow.color
        view.layer.shadowOpacity = Constants.Shadow.opacity
        view.layer.shadowRadius = Constants.Shadow.radius
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        view.addGestureRecognizer(gestureRecognizer)

        let resizingHandleView = ResizingHandleView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(resizingHandleView)
        containerView.addArrangedSubview(contentViewController.view)
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let positionInSuperview = gesture.translation(in: view.superview)

        switch gesture.state {
        case .began:
            panningStart()
        case .changed:
            panningProgress(in: positionInSuperview.y)
        case .ended:
            let velocity = gesture.velocity(in: view)
            panningStop(in: positionInSuperview.y, velocity: velocity.y)
        default:
           break
        }
    }

    private func panningStart() {
        if animator?.isRunning ?? false {
           return
        }

        if let window = self.view.window {
            let targetFrame: CGRect
            var windowFrame = window.frame

            switch currentState {
            case .collapse:
                    windowFrame.size.height -= window.safeAreaInsets.top
                    windowFrame.origin.y = window.safeAreaInsets.top
                    targetFrame = windowFrame
            case .expand:
                // todo right size
                targetFrame = CGRect(x: 0, y: (windowFrame.height - Constants.collapsedHeight), width: windowFrame.width, height: Constants.collapsedHeight)
            }

            animator = UIViewPropertyAnimator(duration: Constants.animationDuration, curve: .linear, animations: { [weak self] in
                self?.view.frame = targetFrame
            })
        }
    }

    private func panningStop(in verticalPos: CGFloat, velocity: CGFloat) {
        gestureRecognizer.isEnabled = false

        let windowHeight = view.window?.frame.height ?? 0
        let shouldReverse: Bool
        let futureState: BottomSheetViewState
        switch currentState {
        case .expand:
            if verticalPos >= windowHeight / 2 || velocity > Constants.velocityThreshold {
                shouldReverse = false
                futureState = .collapse
            } else {
                shouldReverse = true
                futureState = .expand
            }
        case .collapse:
            if verticalPos <= -windowHeight / 2 || velocity <= -1 * Constants.velocityThreshold {
                shouldReverse = false
                futureState = .expand
            } else {
                shouldReverse = true
                futureState = .collapse
            }
        }

        animator?.isReversed = shouldReverse
        animator?.addCompletion { [weak self] _ in
            self?.currentState = futureState
            self?.gestureRecognizer.isEnabled = true

            // when the bottomsheet drawer is expanded, we don't want the UIViews behind the sheet to be accessible.
            self?.view.accessibilityViewIsModal = self?.currentState == .expand
            UIAccessibility.post(notification: .layoutChanged, argument: nil)
        }
        animator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
    }

    private func panningProgress(in verticalPos: CGFloat) {
        if animator?.isRunning ?? false {
           return
        }

        let windowHeight = view.window?.frame.height ?? 0
        var progress = -1 * verticalPos / (windowHeight - Constants.collapsedHeight)

        if currentState == .expand {
            progress *= -1
        }

        animator?.fractionComplete = progress
    }

    private struct Constants {
        static let animationDuration: TimeInterval = 0.5
        static let collapsedHeight: CGFloat = 200
        static let velocityThreshold: CGFloat = 250
        static let cornerRadius: CGFloat = 14

        struct Shadow {
            static let color: CGColor = UIColor.black.cgColor
            static let opacity: Float = 0.2
            static let radius: CGFloat = 4
        }
    }
}
