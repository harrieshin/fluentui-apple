//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

// MARK: TableViewCellDemoController

class ProtoCellDemoController: UITableViewController {
    let sections: [TableViewSampleData.Section] = TableViewCellSampleData.sections

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(style: .grouped)
    }

    override init(style: UITableView.Style) {
        super.init(style: style)
        self.isGrouped = (style == .insetGrouped || style == .grouped)
    }

    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }

    private var isGrouped: Bool = true {
        didSet {
            updateTableView()
        }
    }

    private var isInSelectionMode: Bool = false {
        didSet {
            tableView.allowsMultipleSelection = isInSelectionMode

            for indexPath in tableView?.indexPathsForVisibleRows ?? [] {
                if !sections[indexPath.section].allowsMultipleSelection {
                    continue
                }

                if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
                    cell.setIsInSelectionMode(isInSelectionMode, animated: true)
                }
            }

            tableView.indexPathsForSelectedRows?.forEach {
                tableView.deselectRow(at: $0, animated: false)
            }

            updateNavigationTitle()
            editButton?.title = isInSelectionMode ? "Done" : "Select"
        }
    }

    private var editButton: UIBarButtonItem?

    private var overrideTokens: [TableViewCellTokenSet.Tokens: ControlTokenValue]?

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationController?.isToolbarHidden = false
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.isToolbarHidden = true
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.register(TableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: TableViewHeaderFooterView.identifier)
        tableView.separatorStyle = .none
        tableView.sectionFooterHeight = 0
		tableView.setEditing(true, animated: true)
        updateTableView()
		
		let customButton = Button(style: .accent)
		customButton.sizeCategory = .large
		customButton.setTitle("Merge Now", for: .normal)
		let buttonBarItem = UIBarButtonItem.init(customView: customButton)
		customButton.sizeToFit()
		toolbarItems = [
			buttonBarItem,
		]
    }

    private func updateNavigationTitle() {
            navigationItem.title = "Testing cell"
    }

    private func updateTableView() {
        tableView.backgroundColor = isGrouped ? TableViewCell.tableBackgroundGroupedColor : TableViewCell.tableBackgroundColor
        tableView.reloadData()
    }
}


// MARK: - TableViewCellDemoController: UITableViewDataSource

extension ProtoCellDemoController {
	override func tableView(
		_ tableView: UITableView,
  canEditRowAt indexPath: IndexPath
	) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
	}
	
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewCellSampleData.numberOfItemsInSection
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell, let fluentTheme = view?.fluentTheme else {
            return UITableViewCell()
        }

        let section = sections[indexPath.section]
        let item = section.item
        if section.title == "Inverted double line cell" {
            cell.setup(
                attributedTitle: NSAttributedString(string: item.text1,
                                                    attributes: [.font: UIFont.fluent(fluentTheme.aliasTokens.typography[.body1]),
                                                                 .foregroundColor: UIColor.purple]),
                attributedSubtitle: NSAttributedString(string: item.text2,
                                                       attributes: [.font: UIFont.fluent(fluentTheme.aliasTokens.typography[.caption1]),
                                                                    .foregroundColor: UIColor.red]),
                footer: TableViewCellSampleData.hasFullLengthLabelAccessoryView(at: indexPath) ? "" : item.text3,
                customView: TableViewSampleData.createCustomView(imageName: item.image),
                customAccessoryView: section.hasAccessory ? TableViewCellSampleData.customAccessoryView : nil,
                accessoryType: TableViewCellSampleData.accessoryType(for: indexPath)
            )
        } else {
            cell.setup(
                title: item.text1,
                subtitle: item.text2,
                footer: TableViewCellSampleData.hasFullLengthLabelAccessoryView(at: indexPath) ? "" : item.text3,
                customView: TableViewSampleData.createCustomView(imageName: item.image),
                customAccessoryView: section.hasAccessory ? TableViewCellSampleData.customAccessoryView : nil,
                accessoryType: TableViewCellSampleData.accessoryType(for: indexPath)
            )
        }

        let showsLabelAccessoryView = TableViewCellSampleData.hasLabelAccessoryViews(at: indexPath)

        cell.isUnreadDotVisible = section.isUnreadDotVisible
        cell.titleLeadingAccessoryView = showsLabelAccessoryView ? item.text1LeadingAccessoryView() : nil
        cell.titleTrailingAccessoryView = showsLabelAccessoryView ? item.text1TrailingAccessoryView() : nil
        cell.subtitleLeadingAccessoryView = showsLabelAccessoryView ? item.text2LeadingAccessoryView() : nil
        cell.subtitleTrailingAccessoryView = showsLabelAccessoryView ? item.text2TrailingAccessoryView() : nil
        cell.footerLeadingAccessoryView = showsLabelAccessoryView ? item.text3LeadingAccessoryView() : nil
        cell.footerTrailingAccessoryView = showsLabelAccessoryView ? item.text3TrailingAccessoryView() : nil

        cell.titleNumberOfLines = section.numberOfLines
        cell.subtitleNumberOfLines = section.numberOfLines
        cell.footerNumberOfLines = section.numberOfLines

        cell.titleLineBreakMode = .byTruncatingMiddle

        cell.titleNumberOfLinesForLargerDynamicType = section.numberOfLines == 1 ? 3 : TableViewCell.defaultNumberOfLinesForLargerDynamicType
        cell.subtitleNumberOfLinesForLargerDynamicType = section.numberOfLines == 1 ? 2 : TableViewCell.defaultNumberOfLinesForLargerDynamicType
        cell.footerNumberOfLinesForLargerDynamicType = section.numberOfLines == 1 ? 2 : TableViewCell.defaultNumberOfLinesForLargerDynamicType

        cell.backgroundStyleType = isGrouped ? .grouped : .plain
        cell.topSeparatorType = isGrouped && indexPath.row == 0 ? .full : .none
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.bottomSeparatorType = isGrouped ? .none : .full
        } else {
            cell.bottomSeparatorType = .inset
        }

        cell.isInSelectionMode = section.allowsMultipleSelection ? isInSelectionMode : false

        cell.tokenSet.replaceAllOverrides(with: overrideTokens)

        return cell
    }
}

// MARK: - TableViewCellDemoController: UITableViewDelegate

extension ProtoCellDemoController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeaderFooterView.identifier) as? TableViewHeaderFooterView
        let section = sections[section]
        header?.setup(style: section.headerStyle, title: section.title)
        header?.tableViewCellStyle = tableView.style == .plain ? .plain : .grouped
        return header
    }

    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let title = sections[indexPath.section].item.text1
        showAlertForDetailButtonTapped(title: title)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isInSelectionMode {
            updateNavigationTitle()
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isInSelectionMode {
            updateNavigationTitle()
        }
    }

    private func showAlertForDetailButtonTapped(title: String) {
        let alert = UIAlertController(title: "\(title) detail button was tapped", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
