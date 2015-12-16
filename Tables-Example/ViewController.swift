import UIKit

public protocol Actionable {
    // Imagine all the possiblities
}

protocol Bindable {
    typealias ViewModelType
    
    func bind(viewModel: ViewModelType, pushback: (Actionable -> Actionable)?)
    func unbind()
}

protocol CellConvertible {
    
}

extension Bindable {
    
    func bind(viewModel: ViewModelType, pushback: (Actionable -> Actionable)? = nil) {
        return bind(viewModel, pushback: nil)
    }
    
    func unbind() {
        
    }
}

protocol CellType {
    
    typealias UnderlyingCellType
    
    var reuseIdentifier: String { get }
    func bind(cell: UnderlyingCellType)
}

protocol ViewConvertible {
    
    typealias UnderlyingCellType

    init(cell: UnderlyingCellType)
}

protocol Castable {
    
    typealias UnderlyingCellType
    
    func cast<T: Bindable>(@noescape transform: (UnderlyingCellType) throws -> T) rethrows -> T
}

extension UITableViewCell: Castable {

    typealias UnderlyingCellType = UITableViewCell
    
    func cast<T: Bindable>(@noescape transform: (UnderlyingCellType) throws -> T) rethrows -> T {
        return try transform(self)
    }
}

extension UITableViewHeaderFooterView: Castable {
    
    typealias UnderlyingCellType = UITableViewHeaderFooterView
    
    func cast<T: Bindable>(@noescape transform: (UnderlyingCellType) throws -> T) rethrows -> T {
        return try transform(self)
    }
}

extension UICollectionReusableView: Castable {
    
    typealias UnderlyingCellType = UICollectionReusableView
    
    func cast<T: Bindable>(@noescape transform: (UnderlyingCellType) throws -> T) rethrows -> T {
        return try transform(self)
    }
}

enum Cells {
    case One(String)
    case Two(Int)
}

extension Cells: CellType {
    
    typealias UnderlyingCellType = UITableViewCell
    
    var reuseIdentifier: String {
        switch self {
        case .One:
            return "Cell1"
        case .Two:
            return "Cell2"
        }
    }

    
    func bind(cell: UnderlyingCellType) {
        switch self {
        case let .One(viewModel):
            cell.cast { $0 as! CellView1 }
                .bind(viewModel)
        case let .Two(viewModel):
            cell.cast { $0 as! CellView2 }
                .bind(viewModel)
        }
    }
}

let text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi non enim diam. In ultrices neque mollis tellus sodales, consequat condimentum urna tempor. Nunc condimentum sapien at tincidunt egestas. Sed tempor nibh vel ex dictum sodales quis non lacus. Suspendisse congue dui ut felis lobortis dictum. Vivamus dapibus libero et quam laoreet, eget rhoncus nulla auctor. Sed quis diam sit amet lectus molestie mollis."

class ViewController: UITableViewController {
    
    let array: [Cells] = [.One("Test"), .Two(10), .One(text), .One(text), .One(text), .One(text), .One(text), .One(text), .One(text)]
    let delegate = Delegate()
    let dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate.array = array
        dataSource.array = array
        
        tableView.registerNib(UINib(nibName: "CellView1", bundle: nil), forCellReuseIdentifier: Cells.One("").reuseIdentifier)
        tableView.registerNib(UINib(nibName: "CellView2", bundle: nil), forCellReuseIdentifier: Cells.Two(0).reuseIdentifier)
        
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    // This function will be called when the Dynamic Type user setting changes (from the system Settings app)
    func contentSizeCategoryChanged(notification: NSNotification)
    {
        tableView.reloadData()
    }
}

class Delegate: NSObject, UITableViewDelegate {
    
    var array = [Cells]()
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
//    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return nil
//    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let data = array[indexPath.row]
        data.bind(cell)
        cell.setNeedsUpdateConstraints()
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }
    
    func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        
    }
    
    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
    }
    
    func tableView(tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, estimatedHeightForHeaderAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 0.0
    }
    
    func tableView(tableView: UITableView, estimatedHeightForFooterAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 0.0
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 44.0
//    }
//    
//    func tableView(tableView: UITableView, heightForHeaderAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 0.0
//    }
//    
//    func tableView(tableView: UITableView, heightForFooterAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 0.0
//    }
}


class DataSource: NSObject, UITableViewDataSource {
    
    var array = [Cells]()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = array[indexPath.row]
        return tableView.dequeueReusableCellWithIdentifier(data.reuseIdentifier, forIndexPath: indexPath)
    }
}
