import UIKit

class CellView1: UITableViewCell, Bindable {
        
    @IBOutlet weak var label: UILabel!

    func bind(viewModel: String, pushback: (Actionable -> Actionable)?) {
        label.text = viewModel
    }
    
    func unbind() {
        
    }
}

class CellView2: UITableViewCell, Bindable {
    
    @IBOutlet weak var label: UILabel!
    
    func bind(viewModel: Int, pushback: (Actionable -> Actionable)?) {
        label.text = "\(viewModel)"
    }
    
    func unbind() {
        
    }
}
