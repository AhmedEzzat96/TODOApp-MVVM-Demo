import UIKit

protocol SignInVCProtocol: class {
    func showIndicator()
    func hideIndicator()
    func openAlert(title: String, message: String)
    func goToMainVC()
}

class SignInVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet var signinView: SigninView!
    
    // MARK:- Properties
    var presenter: SignInViewModelProtocol!
    
    // MARK:- Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        signinView.setupView()
    }
    
    // MARK:- IBActions
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        let user = User(email: signinView.emailTextField.text, password: signinView.passwordTextField.text)
        presenter.goToMainScreen(with: user)
    }
    
    @IBAction func createAccBtnPressed(_ sender: UIButton) {
        let signUpVC = SignUpVC.create()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    // MARK:- Public Methods
    class func create() -> SignInVC {
        let signInVC: SignInVC = UIViewController.create(storyboardName: Storyboards.authentication, identifier: ViewControllers.signInVC)
        signInVC.presenter = SignInViewModel(view: signInVC)
        return signInVC
    }
}

//MARK:- Protocol Methods
extension SignInVC: SignInVCProtocol {
   func showIndicator() {
        view.showActivityIndicator()
    }
    
    func hideIndicator() {
        view.hideActivityIndicator()
    }
    
    func openAlert(title: String, message: String) {
     openAlert(title: title, message: message, alertStyle: .alert, actionTitles: ["OK"], actionStyles: [.cancel], actions: nil)
    }
    
    func goToMainVC() {
        let todoListVC = TodoListVC.create()
        let todoListNav = UINavigationController(rootViewController: todoListVC)
        AppDelegate.shared().window?.rootViewController = todoListNav
    }
}
