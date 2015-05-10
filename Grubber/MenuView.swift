//
//  CustomView.swift
//
//  Code generated using QuartzCode 1.23 on 5/3/15.
//  www.quartzcodeapp.com
//

import UIKit

@IBDesignable
class CustomView: UIView {
    var roundedrect : CAShapeLayer!
    var roundedrect2 : CAShapeLayer!
    var roundedrect3 : CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupLayers()
    }
    
    func setupLayers(){
        roundedrect = CAShapeLayer()
        roundedrect.anchorPoint = CGPointMake(0.5, 2.5)
        roundedrect.frame       = CGRectMake(0.5, 2.48, 19.99, 3.21)
        roundedrect.setValue(-90 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        roundedrect.fillColor   = UIColor.whiteColor().CGColor
        roundedrect.strokeColor = UIColor.whiteColor().CGColor
        roundedrect.path        = roundedRectPath().CGPath;
        self.layer.addSublayer(roundedrect)
        
        roundedrect2 = CAShapeLayer()
        roundedrect2.frame       = CGRectMake(0.39, 8.68, 19.99, 3.21)
        roundedrect2.setValue(-90 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        roundedrect2.fillColor   = UIColor.whiteColor().CGColor
        roundedrect2.strokeColor = UIColor.whiteColor().CGColor
        roundedrect2.path        = roundedRect2Path().CGPath;
        self.layer.addSublayer(roundedrect2)
        
        roundedrect3 = CAShapeLayer()
        roundedrect3.anchorPoint   = CGPointMake(0.5, -1.4)
        roundedrect3.frame         = CGRectMake(0.5, 14.89, 19.99, 3.21)
        roundedrect3.setValue(-90 * CGFloat(M_PI)/180, forKeyPath:"transform.rotation")
        roundedrect3.fillColor     = UIColor.whiteColor().CGColor
        roundedrect3.strokeColor   = UIColor.whiteColor().CGColor
        roundedrect3.lineDashPhase = 1
        roundedrect3.path          = roundedRect3Path().CGPath;
        self.layer.addSublayer(roundedrect3)
    }
    
    
    @IBAction func startAllAnimations(sender: AnyObject!){
        roundedrect?.addAnimation(roundedRectAnimation(), forKey:"roundedRectAnimation")
        roundedrect2?.addAnimation(roundedRect2Animation(), forKey:"roundedRect2Animation")
        roundedrect3?.addAnimation(roundedRect3Animation(), forKey:"roundedRect3Animation")
    }
    
    
    @IBAction func startReverseAnimations(sender: AnyObject!){
        var totalDuration = CGFloat(0.2)
        roundedrect?.addAnimation(QCMethod.reverseAnimation(roundedRectAnimation(), totalDuration:totalDuration), forKey:"roundedRectAnimation")
        roundedrect2?.addAnimation(QCMethod.reverseAnimation(roundedRect2Animation(), totalDuration:totalDuration), forKey:"roundedRect2Animation")
        roundedrect3?.addAnimation(QCMethod.reverseAnimation(roundedRect3Animation(), totalDuration:totalDuration), forKey:"roundedRect3Animation")
    }
    
    func roundedRectAnimation() -> CABasicAnimation{
        var transformAnim       = CABasicAnimation(keyPath:"transform")
        transformAnim.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 1));
        transformAnim.duration  = 0.2
        transformAnim.fillMode = kCAFillModeBoth
        transformAnim.removedOnCompletion = false
        
        return transformAnim;
    }
    
    func roundedRect2Animation() -> CABasicAnimation{
        var transformAnim       = CABasicAnimation(keyPath:"transform")
        transformAnim.fromValue = NSValue(CATransform3D: CATransform3DIdentity);
        transformAnim.duration  = 0.2
        transformAnim.fillMode = kCAFillModeBoth
        transformAnim.removedOnCompletion = false
        
        return transformAnim;
    }
    
    func roundedRect3Animation() -> CABasicAnimation{
        var transformAnim       = CABasicAnimation(keyPath:"transform")
        transformAnim.fromValue = NSValue(CATransform3D: CATransform3DIdentity);
        transformAnim.duration  = 0.2
        transformAnim.fillMode = kCAFillModeBoth
        transformAnim.removedOnCompletion = false
        
        return transformAnim;
    }
    
    //MARK: - Bezier Path
    
    func roundedRectPath() -> UIBezierPath{
        var roundedRectPath = UIBezierPath(roundedRect:CGRectMake(0, 0, 20, 3), cornerRadius:2)
        return roundedRectPath;
    }
    
    func roundedRect2Path() -> UIBezierPath{
        var roundedRect2Path = UIBezierPath(roundedRect:CGRectMake(0, 0, 20, 3), cornerRadius:2)
        return roundedRect2Path;
    }
    
    func roundedRect3Path() -> UIBezierPath{
        var roundedRect3Path = UIBezierPath(roundedRect:CGRectMake(0, 0, 20, 3), cornerRadius:2)
        return roundedRect3Path;
    }
    
}
