//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let databaseService: DataBaseService
    private var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Company> = {
        let fetchRequest = NSFetchRequest<Company>(entityName:"Company")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending:true)]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: appDelegate.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    init(databaseService: DataBaseService) {
        self.databaseService = databaseService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        self.tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CompanyCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = true
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(self.tableView)
        
//        NSLayoutConstraint(item: self.tableView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 8.0).isActive = true
//        NSLayoutConstraint(item: self.tableView!, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 8.0).isActive = true
//        NSLayoutConstraint(item: self.tableView!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 8.0).isActive = true
//        NSLayoutConstraint(item: self.tableView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 8.0).isActive = true
        
        self.databaseService.fetchCompanies { error in
            if let error = error {
                print("ViewController::viewDidLoad fetch error \(error)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let company = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell", for: indexPath)
        
        var companyNameLabel = cell.viewWithTag(1) as? UILabel
        if companyNameLabel == nil {
            companyNameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
            companyNameLabel?.tag = 1
            cell.addSubview(companyNameLabel!)
        }
        companyNameLabel?.textColor = UIColor.black
        companyNameLabel?.font = UIFont.systemFont(ofSize: 20)
        companyNameLabel?.text = company.name
        
        NSLayoutConstraint(item: companyNameLabel!, attribute: .trailing, relatedBy: .equal, toItem: cell, attribute: .trailingMargin, multiplier: 1.0, constant: 8.0).isActive = true
        NSLayoutConstraint(item: companyNameLabel!, attribute: .leading, relatedBy: .equal, toItem: cell, attribute: .leadingMargin, multiplier: 1.0, constant: 8.0).isActive = true
        NSLayoutConstraint(item: companyNameLabel!, attribute: .top, relatedBy: .equal, toItem: cell, attribute: .topMargin, multiplier: 1.0, constant: 8.0).isActive = true
        NSLayoutConstraint(item: companyNameLabel!, attribute: .bottom, relatedBy: .equal, toItem: cell, attribute: .bottomMargin, multiplier: 1.0, constant: 8.0).isActive = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Segue", sender: self)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        if identifier == "Segue" {
            let company = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
            let controller = CompanyInfoViewController(company: company, databaseService: self.databaseService)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.reloadData()
    }
}
