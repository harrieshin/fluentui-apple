//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit
import SwiftUI

// MARK: - DrawerDemoController

class DrawerDemoController: DemoController {

    private var verticalDrawerController: MSFDrawer?
    private var horizontalDrawerController: MSFDrawer?
    var verticalContentController: DrawerVerticalContentController?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(showTopDrawerButtonTapped))

        addTitle(text: "Top Drawer")

        container.addArrangedSubview(createButton(title: "Show resizable with clear background", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showTopDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show resizable with max content height", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showTopDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show non dismissable", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showTopDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show changing resizing behaviour", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showTopDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show with no animation", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showTopDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show from custom base with width on landscape", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender.view
            guard let rect = buttonView.superview?.convert(buttonView.frame, to: nil) else {
                return
            }

            strongSelf.showTopDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show respecting safe area width", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showTopDrawerButtonTapped()
        }).view)

        addTitle(text: "Left/Right Drawer")
        addRow(items: [
            createButton(title: "Show from leading with clear background", action: { [weak self ] _ in
                if let strongSelf = self {
                    strongSelf.showLeftDrawerClearBackgroundButtonTapped()
                }
            }).view,
            createButton(title: "Show from trailing with clear background", action: { [weak self ] _ in
                if let strongSelf = self {
                    strongSelf.showRightDrawerClearBackgroundButtonTapped()
                }
            }).view
        ],
        itemSpacing: Constants.verticalSpacing,
        stretchItems: true)
        addRow(items: [
            createButton(title: "Show from leading with dimmed background", action: { [weak self ] _ in
                if let strongSelf = self {
                    strongSelf.showLeftDrawerDimmedBackgroundButtonTapped()
                }
            }).view,
            createButton(title: "Show from trailing with dimmed background", action: { [weak self ] _ in
                if let strongSelf = self {
                    strongSelf.showRightDrawerDimmedBackgroundButtonTapped()
                }
            }).view
        ],
        itemSpacing: Constants.verticalSpacing,
        stretchItems: true)
        addDescription(text: "Swipe from the left or right edge of the screen to reveal a drawer interactively")

        addTitle(text: "Bottom Drawer")

        container.addArrangedSubview(createButton(title: "Show resizable", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showBottomDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show resizable with max content height", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showBottomDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show with underlying interactable content view", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.navigationController?.pushViewController(PassThroughDrawerDemoController(), animated: true)
        }).view)
        container.addArrangedSubview(createButton(title: "Show changing resizing behaviour", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showBottomDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show with no animation", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showBottomDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show from custom base", action: { [weak self] sender in
            guard let strongSelf = self else {
                return
            }

            let buttonView = sender.view
            guard let rect = buttonView.superview?.convert(buttonView.frame, to: nil) else {
                return
            }

            strongSelf.showBottomDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show always as slideover, resizable with dimmed background", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showBottomDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show always as slideover, resizable with clear background", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showBottomDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show with focusable content", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showBottomDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(createButton(title: "Show dismiss blocking drawer", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.showBottomDrawerButtonTapped()
        }).view)

        container.addArrangedSubview(UIView())

        // Screen edge gestures to interactively present side drawers

        let isLeadingEdgeLeftToRight = view.effectiveUserInterfaceLayoutDirection == .leftToRight

        let leadingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan))
        leadingEdgeGesture.edges = isLeadingEdgeLeftToRight ? .left : .right
        view.addGestureRecognizer(leadingEdgeGesture)
        navigationController?.navigationController?.interactivePopGestureRecognizer?.require(toFail: leadingEdgeGesture)

        let trailingEdgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePan))
        trailingEdgeGesture.edges = isLeadingEdgeLeftToRight ? .right : .left
        view.addGestureRecognizer(trailingEdgeGesture)

        horizontalDrawerController = MSFDrawer(contentViewController: DrawerHorizontalContentController())
        horizontalDrawerController?.delegate = self

        self.verticalContentController = DrawerVerticalContentController()
        if let containerController = self.verticalContentController {
            verticalDrawerController = MSFDrawer(contentViewController: containerController)
            verticalDrawerController?.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    private func showLeftDrawerClearBackgroundButtonTapped() {
        if let drawerController = horizontalDrawerController {
            drawerController.state.backgroundDimmed = false
            drawerController.state.presentationDirection = .left
            present(drawerController, animated: true, completion: nil)
        }
    }

    private func showLeftDrawerDimmedBackgroundButtonTapped() {
        if let drawerController = horizontalDrawerController {
            drawerController.state.backgroundDimmed = true
            drawerController.state.presentationDirection = .left
            present(drawerController, animated: true, completion: nil)
        }
    }

    private func showRightDrawerClearBackgroundButtonTapped() {
        if let drawerController = horizontalDrawerController {
            drawerController.state.backgroundDimmed = false
            drawerController.state.presentationDirection = .right
            present(drawerController, animated: true, completion: nil)
        }
    }

    private func showRightDrawerDimmedBackgroundButtonTapped() {
        if let drawerController = horizontalDrawerController {
            drawerController.state.backgroundDimmed = true
            drawerController.state.presentationDirection = .right
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func showTopDrawerButtonTapped() {
        if let drawerController = verticalDrawerController {
            drawerController.state.backgroundDimmed = false
            drawerController.state.presentationDirection = .top
            present(drawerController, animated: true, completion: nil)
        }
    }

    private func showBottomDrawerButtonTapped() {
        if let drawerController = verticalDrawerController {
            drawerController.state.backgroundDimmed = false
            drawerController.state.presentationDirection = .bottom
            present(drawerController, animated: true, completion: nil)
        }
    }

    @objc private func handleScreenEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }

        var isleftPresentation = gesture.velocity(in: view).x > 0
        if view.effectiveUserInterfaceLayoutDirection == .rightToLeft {
            isleftPresentation.toggle()
        }

        if let drawerController = horizontalDrawerController {
            drawerController.state.backgroundDimmed = true
            drawerController.state.presentingGesture = gesture
            drawerController.state.presentationDirection = isleftPresentation ? .left : .right
            present(drawerController, animated: true, completion: nil)
        }
    }
}

extension DrawerDemoController: MSFDrawerControllerDelegate {
    @objc func drawerDidChangeState(state: MSFDrawerState, controller: UIViewController) {
        if let controller = verticalContentController {
            controller.expandButton?.state.text = state.isExpanded ? "Return to normal" : "Expand"
        }
    }

}

// MARK: DrawerContentController

class DrawerHorizontalContentController: DemoController {

    public func actionViews() -> [UIView] {
        let spacer = UIView()
        spacer.backgroundColor = .orange
        spacer.layer.borderWidth = 1
        spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

        var views = [UIView]()
        views.append(createButton(title: "Dismiss", action: { [weak self ] _ in
            if let strongSelf = self {
                strongSelf.dismissButtonTapped()
            }
        }).view)
        views.append(createButton(title: "Dismiss (no animation)", action: { [weak self ] _ in
            if let strongSelf = self {
                strongSelf.dismissNotAnimatedButtonTapped()
            }
        }).view)
        views.append(spacer)
        return views
    }

    public func containerForActionViews() -> UIView {
        let container = DemoController.createVerticalContainer()
        for view in actionViews() {
            container.addArrangedSubview(view)
        }
        addBackgroundColor(container, color: Colors.surfacePrimary)
        return container
    }

    private func addBackgroundColor(_ stackview: UIStackView, color: UIColor) {
        let subView = UIView(frame: stackview.bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackview.insertSubview(subView, at: 0)
    }

    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func dismissNotAnimatedButtonTapped() {
        dismiss(animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = containerForActionViews()
    }
}

class DrawerVerticalContentController: DemoController {

    public var expandButton: MSFButton?
    public var drawerHasFlexibleHeight: Bool = true
    public var drawerHasToggleResizingBehaviorButton: Bool = true

    private func actionViews() -> [UIView] {
        let spacer = UIView()
        spacer.backgroundColor = .orange
        spacer.layer.borderWidth = 1
        spacer.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true

        var views = [UIView]()
        if drawerHasFlexibleHeight {
            let expandButton = createButton(title: "Expand", action: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }

                guard let drawer = strongSelf.presentedViewController as? DrawerController else {
                    return
                }
                drawer.isExpanded = !drawer.isExpanded
            })

            self.expandButton = expandButton
            views.append(createButton(title: "Change content height", action: { sender in
                if let spacer = (sender.view.superview as? UIStackView)?.arrangedSubviews.last,
                    let heightConstraint = spacer.constraints.first {
                    heightConstraint.constant = heightConstraint.constant == 20 ? 100 : 20
                }
            }).view)
            views.append(expandButton.view)
        }

        views.append(createButton(title: "Dismiss", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dismiss(animated: true)
        }).view)

        views.append(createButton(title: "Dismiss (no animation)", action: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dismiss(animated: false)
        }).view)

        if drawerHasToggleResizingBehaviorButton {
            views.append(createButton(title: "Resizing - None", action: { [weak self] sender in
                guard let strongSelf = self else {
                    return
                }

                guard let drawer = strongSelf.presentedViewController as? DrawerController else {
                    return
                }

                let isResizingBehaviourNone = drawer.resizingBehavior == .none
                drawer.resizingBehavior = isResizingBehaviourNone ? .expand : .none
                sender.state.text = isResizingBehaviourNone ? "Resizing - None" : "Resizing - Expand"
            }).view)
        }
        views.append(spacer)
        return views
    }

    public func containerForActionViews() -> UIView {
        let container = DemoController.createVerticalContainer()
        for view in actionViews() {
            container.addArrangedSubview(view)
        }
        addBackgroundColor(container, color: Colors.surfacePrimary)
        return container
    }

    private func addBackgroundColor(_ stackview: UIStackView, color: UIColor) {
        let subView = UIView(frame: stackview.bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackview.insertSubview(subView, at: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view = containerForActionViews()
    }
}
