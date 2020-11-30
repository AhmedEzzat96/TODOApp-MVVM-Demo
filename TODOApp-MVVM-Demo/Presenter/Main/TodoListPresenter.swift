
import Foundation

protocol TodoListPresenterProtocol {
    func viewDidLoad()
    func getAllTasks()
    func getTasksCount() -> Int
    func configure(cell: TaskCell, for index: Int)
    func deleteTaskAlert(with index: Int)
}

class TodoListPresenter {
    
    //MARK:- Properties
    private weak var view: TodoListVCProtocol?
    private var tasks = [TaskData]()
    
    // MARK:- Life Cycle Methods
    init(view: TodoListVCProtocol) {
        self.view = view
    }
}

//MARK:- Protocol Methods
extension TodoListPresenter: TodoListPresenterProtocol {
    func viewDidLoad() {
        getAllTasks()
    }
    
    func getAllTasks() {
        self.view?.showIndicator()
        APIManager.getAllTasks { [weak self] (response) in
            guard let self = self else {return}
            switch response {
                
            case .success(let taskData):
                self.tasks = taskData.data
                
                if self.tasks.count <= 0 {
                    DispatchQueue.main.async {
                        self.view?.noTasksFound()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.view?.fetchingData()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.view?.hideIndicator()
        }
    }
    
    func getTasksCount() -> Int {
        return tasks.count
    }
    
    func configure(cell: TaskCell, for index: Int) {
        let task = tasks[index]
        cell.descriptionLabel.text = task.description
    }
    
    func deleteTaskAlert(with index: Int) {
        view?.openAlertWithAction(title: "Sorry", message: "Are You Sure Want to Delete this TODO?", actionTitles: ["No", "Yes"], actionStyles: [.cancel, .destructive], actions: [nil, { [weak self] yesAction in
            self?.deleteTask(with: index)
            }])
    }
}

//MARK:- Private Methods
extension TodoListPresenter {
    // delete task by id from api
    private func deleteTask(with index: Int) {
        self.view?.showIndicator()
        guard let id = tasks[index].id else {return}
        APIManager.deleteTask(with: id) { [weak self] (success) in
            if success {
                self?.getAllTasks()
                print("Task Deleted")
            } else {
                print("Error")
            }
            self?.view?.hideIndicator()
        }
    }
}
