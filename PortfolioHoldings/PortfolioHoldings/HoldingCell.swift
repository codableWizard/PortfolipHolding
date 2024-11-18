import UIKit

class HoldingCell: UITableViewCell {

    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblLtp: UILabel!
    @IBOutlet weak var lblPnl: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with model : HoldingModel){
        lblSymbol.text = model.symbol
        if let ltp = model.ltp{
            lblLtp.text = ltp.toCommaSeperatedAmount()
        }else{
            lblLtp.text = "-"
        }
        
        lblPnl.text = model.getTotalPnL().toCommaSeperatedAmount()
        if model.isInLoss == true {
            lblPnl.textColor = UIColor.red
        }else{
            lblPnl.textColor = UIColor.systemGreen
        }
        
        if let qty = model.quantity{
            lblQty.text = "\(qty)"
        }else{
            lblQty.text = "-"
        }
    }
    
}
