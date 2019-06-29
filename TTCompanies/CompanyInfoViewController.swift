//
//  Copyright © 2019 aleksandrpravda. All rights reserved.
//

import UIKit

class CompanyInfoViewController: UIViewController {
    
    private var descriptionLabel: UILabel!
    private var company: Company
    private let databaseService: DataBaseService
    private var observer: CoreDataContextObserver<Company>?
    
    init(company: Company, databaseService: DataBaseService) {
        self.databaseService = databaseService
        self.company = company
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.descriptionLabel.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        self.descriptionLabel.textColor = UIColor.black
        self.descriptionLabel.font = UIFont.systemFont(ofSize: 20)
        self.descriptionLabel.numberOfLines = 0
        self.view.addSubview(self.descriptionLabel)
        
        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            self.descriptionLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
            self.descriptionLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant:  8.0).isActive = true
            self.descriptionLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant:  8.0).isActive = true
            self.descriptionLabel.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier:  0.5).isActive = true
            
        } else {
            NSLayoutConstraint(item: self.descriptionLabel!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 8.0).isActive = true
            NSLayoutConstraint(item: self.descriptionLabel!, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 8.0).isActive = true
            NSLayoutConstraint(item: self.descriptionLabel!, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 8.0).isActive = true
            self.descriptionLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.observer = CoreDataContextObserver<Company>(context: context)
        observer?.observeObject(object: company, state: .updated) { [weak self] updatedObject, state in
            self?.descriptionLabel.text = updatedObject.description
        }
        if let id = self.company.id {
            self.databaseService.updateCompany(by: id) { error in
                if let error = error {
                    print("ViewController::viewDidLoad fetch error \(error)")
                }
            }
        }
    }
    
    deinit {
        self.observer?.unobserveObject(object: self.company, forState: .updated)
    }
}
