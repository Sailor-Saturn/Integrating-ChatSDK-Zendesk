//
//  ViewController.swift
//  ChatSDK_Auth
//
//  Created by Killian Smith  on 04/08/2020.
//  Copyright © 2020 Zendesk. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    private var modalBackButton: UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: .close,
                        target: self,
                        action: #selector(dismissViewController))
        button.tintColor = .black
        return button
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /// Dismiss modal `viewController` action
    @objc private func dismissViewController() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func showChatSDK(_ sender: Any) {
        do {
            let viewController = try ZendeskMessaging.instance.buildMessagingViewController()
            
            viewController.navigationItem.leftBarButtonItem = modalBackButton
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .pageSheet
            present(navigationController, animated: true)
        } catch {
            print(error)
        }
    }
}

