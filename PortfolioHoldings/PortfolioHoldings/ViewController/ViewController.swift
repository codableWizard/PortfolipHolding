import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tblHoldings: UITableView! {
        didSet{
            tblHoldings.delegate = self
            tblHoldings.dataSource = self
            tblHoldings.register(UINib(nibName: "HoldingCell", bundle: nil), forCellReuseIdentifier: "HoldingCell")

        }
    }
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var lblCurValue: UILabel!
    @IBOutlet weak var lblTotalInv: UILabel!
    @IBOutlet weak var lblTodaysPnL: UILabel!
    @IBOutlet weak var lblTotalPnL: UILabel!
    @IBOutlet weak var expandedView: UIView!{
        didSet{
            self.expandedView.layer.cornerRadius = 4.0
            self.expandedView.isHidden = true
        }
    }
    @IBOutlet weak var pnlView: UIView!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var stkView: UIStackView!
    
    private var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        showLoader()
        viewModel.fetchHoldings()
    }

    private func showLoader(){
        tblHoldings.isHidden = true
        baseView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    private func hideLoader(){
        tblHoldings.isHidden = false
        activityIndicatorView.stopAnimating()
        baseView.isHidden = true
        setupLabels()
    }
    
    private func setupLabels(){
        let totalPnl = viewModel.totalPnLAmt
        let todaysPnl = viewModel.todaysPnLAmt
        lblCurValue.text = viewModel.currentValue.toCommaSeperatedAmount()
        lblTotalInv.text = viewModel.totalInvAmt.toCommaSeperatedAmount()
        lblTodaysPnL.text = todaysPnl.toCommaSeperatedAmount()
        lblTotalPnL.text = totalPnl.toCommaSeperatedAmount()
        
        if totalPnl < 0 {
            lblTotalPnL.textColor = UIColor.red
        }else{
            lblTotalPnL.textColor = UIColor.systemGreen
        }

        if todaysPnl < 0 {
            lblTodaysPnL.textColor = UIColor.red
        }else{
            lblTodaysPnL.textColor = UIColor.systemGreen
        }

    }

    @IBAction func bottomViewTapped(_ sender: UIButton) {
        self.expandedView.isHidden = !self.expandedView.isHidden

        UIView.animate(withDuration: 0.5) { () -> Void in
            self.imgArrow.transform = CGAffineTransform(rotationAngle: self.expandedView.isHidden ? 0 : CGFloat.pi)
            self.stkView.layoutIfNeeded()
        }
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRowsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellModel = viewModel.getCellModel(for: indexPath.row){
            let cell : HoldingCell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.holdingCell, for: indexPath) as! HoldingCell
            cell.configureCell(with: cellModel)
            return cell
        }else{
            return UITableViewCell()
        }
    }
}


extension ViewController : HoldingsVMProtocol{
    func fetchedHoldingsUpdateUI() {
        hideLoader()
        tblHoldings.reloadData()
    }
    
    func errorInAPI(){
        hideLoader()
        showUnexpectedError()
    }
    
    private func showUnexpectedError(){
        let alertController = UIAlertController(title: "Unable to fetch data", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (alertAction) in
            //todo
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
