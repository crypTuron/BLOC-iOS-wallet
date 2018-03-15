//  
//  ExportWalletKeysVC.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 15/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import UIKit
import EFQRCode

protocol ExportWalletKeysDisplayLogic: class {
    func handleUpdate(viewModel: ExportWalletKeysViewModel)
}

class ExportWalletKeysVC: ViewController, ExportWalletKeysDisplayLogic {
    enum Mode {
        case creation
        case export
    }
    
    let formView = ScrollableStackView()
    let formFields = ExportWalletKeysFormViews()

    let router: ExportWalletKeysRoutingLogic
    let interactor: ExportWalletKeysBusinessLogic
    
    let wallet: WalletModel
    let mode: Mode
    
    // MARK: - View lifecycle
    
    init(wallet: WalletModel, mode: Mode) {
        let interactor = ExportWalletKeysInteractor()
        let presenter = ExportWalletKeysPresenter()
        let router = ExportWalletKeysRouter()
        
        self.router = router
        self.interactor = interactor
        
        self.wallet = wallet
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
        
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    init(router: ExportWalletKeysRoutingLogic, interactor: ExportWalletKeysBusinessLogic, wallet: WalletModel, mode: Mode) {
        self.router = router
        self.interactor = interactor
        
        self.wallet = wallet
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
        interactor.getKeys(request: ExportWalletKeysRequest(wallet: wallet))
    }

    // MARK: - Configuration
    
    func configure() {
        view.backgroundColor = .clear
        
        view.addSubview(formView)
        
        formView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
        
        // Form
        
        formView.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 60.0, right: 0.0)
        formFields.orderedViews.forEach(formView.stackView.addArrangedSubview)
        
        formFields.walletQRCodeImageView.snp.makeConstraints({
            $0.height.equalTo(200.0)
        })

        formFields.printButton.addTarget(self, action: #selector(printTapped), for: .touchUpInside)
        formFields.goToWalletButton.addTarget(self, action: #selector(goToWalletTapped), for: .touchUpInside)

        // Navigation Bar
        
        let titleView = TitleView(title: R.string.localizable.home_menu_wallet_title(), subtitle: R.string.localizable.home_menu_wallet_subtitle())
        self.navigationItem.titleView = titleView
        
        let backButton = UIBarButtonItem(image: R.image.leftArrow(), style: .plain, target: self, action: #selector(goToWalletTapped))
        self.navigationItem.setLeftBarButton(backButton, animated: false)
    }
    
    // MARK: Actions
    
    @objc func printTapped() {
        router.showPrintPreview()
    }
    
    @objc func goToWalletTapped() {
        router.goToWallet(wallet: wallet)
    }

    // MARK: UI Update
    
    func handleUpdate(viewModel: ExportWalletKeysViewModel) {
        // TODO: Loading state
        // TODO: Error state
        
        switch viewModel.state {
        case .loaded(let keys):
            if let qrCode = EFQRCode.generate(content: keys, size: EFIntSize(width: Int(200 * UIScreen.main.scale), height: Int(200 * UIScreen.main.scale)), backgroundColor: UIColor.black.cgColor, foregroundColor: UIColor.white.cgColor, watermark: nil) {
                formFields.walletQRCodeImageView.image = UIImage(cgImage: qrCode)
            }
            
            formFields.walletKeyLabel.text = keys
        default:
            break
        }
        
        view.layoutSubviews()
    }
}
