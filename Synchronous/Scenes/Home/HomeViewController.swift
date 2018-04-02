//
//  HomeViewController.swift
//  Synchronous
//
//  Created by Raymond Law on 2/22/18.
//  Copyright (c) 2018 Clean Swift LLC. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeDisplayLogic: class
{
  func displayVIPCycle(viewModel: Home.VIPCycle.ViewModel)
}

class HomeViewController: UIViewController, HomeDisplayLogic
{
  var interactor: HomeBusinessLogic?
  var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = HomeInteractor()
    let presenter = HomePresenter()
    let router = HomeRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
  }
  
  // MARK: Use cases
  
  @IBOutlet weak var stateVariableLabel: UILabel!
  
  @IBAction func stateVariableButtonTapped(_ sender: Any)
  {
    let request = Home.StateVariable.Request()
    interactor?.stateVariable(request: request)
    let result = (interactor?.result)!
    stateVariableLabel.text = result
  }
  
  @IBOutlet weak var returnValueLabel: UILabel!
  
  @IBAction func returnValueButtonTapped(_ sender: Any)
  {
    let request = Home.ReturnValue.Request()
    let result = (interactor?.returnValue(request: request))!
    returnValueLabel.text = result
  }
  
  @IBOutlet weak var inOutParameterLabel: UILabel!
  
  @IBAction func inOutParameterButtonTapped(_ sender: Any)
  {
    let request = Home.InOutParameter.Request()
    var result: String = ""
    interactor?.inOutParameter(request: request, result: &result)
    inOutParameterLabel.text = result
  }
  
  @IBOutlet weak var completionHandlerLabel: UILabel!
  
  @IBAction func completionHandlerButtonTapped(_ sender: Any)
  {
    let request = Home.CompletionHandler.Request()
    interactor?.completionHandler(request: request, completionHandler: { (result) in
      completionHandlerLabel.text = result
    })
  }
  
  @IBOutlet weak var vipCycleLabel: UILabel!
  
  @IBAction func vipCycleButtonTapped(_ sender: Any)
  {
    let request = Home.VIPCycle.Request()
    interactor?.vipCycle(request: request)
  }
  
  func displayVIPCycle(viewModel: Home.VIPCycle.ViewModel)
  {
    let result = viewModel.result
    vipCycleLabel.text = result
  }
}
