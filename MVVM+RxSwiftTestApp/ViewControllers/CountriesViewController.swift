//
//  CountriesViewController.swift
//  MVVM+RxSwiftTestApp
//
//  Created by devil1001 on 21/03/2019.
//  Copyright © 2019 devil1001. All rights reserved.
//

import UIKit
import RxSwift

final class CountriesViewController: UIViewController, ErrorDialogPresenter {
    @IBOutlet var tableView: UITableView!
    
    let viewModel: CountriesTableViewModel = CountriesTableViewModel()
    private let disposeBag = DisposeBag()
    private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupCellTapHandling()
        viewModel.getCountries()
    }
    
    func bindViewModel() {
        viewModel.countryCells.bind(to: self.tableView.rx.items) { tableView, index, element in
            self.effectView.removeFromSuperview()
            let indexPath = IndexPath(item: index, section: 0)
            switch element {
            case .normal(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryTableViewCell else {
                    return UITableViewCell()
                }
                cell.viewModel = viewModel
                return cell
            case .error(let message):
                let cell = UITableViewCell()
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = message
                return cell
            case .empty:
                let cell = UITableViewCell()
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = "No data available"
                return cell
            }
            }.disposed(by: disposeBag)
        
        viewModel
            .onShowError
            .map { [weak self] in
                self?.presentErrorDialog(alert: $0)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel
            .onShowLoadingHud
            .map { [weak self] in self?.setLoadingHud(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    private func setLoadingHud(visible: Bool) {
        showLoadingIndicator(on: effectView)
    }
    
    private func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(CountryCellType.self)
            .subscribe(
                onNext: { [weak self] countryCellType in
                    if case .normal(_) = countryCellType {
                        self?.performSegue(withIdentifier: "CountryDetails", sender: self)
                    }
                    if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                        self?.tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    public override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
}
