//  
//  ListTransactionsInteractor.swift
//  BlockChain-Coin
//
//  Created by Maxime Bornemann on 12/03/2018.
//  Copyright © 2018 BlockChain-Coin.net. All rights reserved.
//

import Foundation

protocol ListTransactionsBusinessLogic {
    var presenter: ListTransactionsPresentationLogic? { get set }

}

class ListTransactionsInteractor: ListTransactionsBusinessLogic {
    var presenter: ListTransactionsPresentationLogic?
    
    init() {

    }
}