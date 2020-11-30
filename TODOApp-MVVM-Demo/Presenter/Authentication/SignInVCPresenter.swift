
import Foundation

protocol SignInPresenterProtocol {
    func goToMainScreen(with user: User?)
}

class SignInVCPresenter {
    
    //MARK:- Properties
    private weak var view: SignInVCProtocol?
    
    // MARK:- Life Cycle Methods
    init(view: SignInVCProtocol) {
        self.view = view
    }
}

// MARK:- Protocol Methods
extension SignInVCPresenter: SignInPresenterProtocol {
    func goToMainScreen(with user: User?) {
        if validateUser(with: user) {
            signIn(with: user!)
        }
    }
}

// MARK:- Private Methods
extension SignInVCPresenter {
    private func signIn(with user: User) {
        view?.showIndicator()
        APIManager.login(with: user) { [weak self] (response) in
            guard let self = self else { return }
            switch response {
            case .success(let loginData):
                UserDefaultsManager.shared().token = loginData.token
                UserDefaultsManager.shared().id = loginData.user.id
                self.view?.goToMainVC()
            case .failure(let error):
                print(error.localizedDescription)
                self.view?.openAlert(title: "Your email or password is wrong", message: "please enter valid email or password")
            }
            
            DispatchQueue.main.async {
                self.view?.hideIndicator()
            }
        }
        
    }
    
    private func validateUser(with user: User?) -> Bool {
        if !ValidatorManager.shared().isValid(with: user?.email, validationType: .email) {
            view?.openAlert(title: ValidationType.email.error.title, message: ValidationType.email.error.message)
            return false
        }
        if !ValidatorManager.shared().isValid(with: user?.password, validationType: .password) {
            view?.openAlert(title: ValidationType.password.error.title, message: ValidationType.password.error.message)
            return false
        }
        return true
    }
}
