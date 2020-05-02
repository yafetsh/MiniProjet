//
//  ViewController.swift
//  ProjetIOS
//
//  Created by Yafet Shil on 21/11/2019.
//  Copyright © 2019 4SIM4. All rights reserved.
//

import UIKit
import BATabBarController

class AcceuilViewController:  UIViewController{
    enum DemoTypes {
          case BATabBarWithText
          case BATabBarNoText
      }
      
      var  demotype = DemoTypes.BATabBarNoText
    
    
    @IBOutlet weak var prenom: UILabel!
    var usr : String = ""
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
navigationItem.leftBarButtonItem = backButton

        super.viewDidLoad()
        let nom = defaults.object(forKey: "user_name") as? String
        let prenom_connected = defaults.object(forKey: "user_prenom") as? String
        prenom.text = "Bienvenue \(String(prenom_connected!)) \(String(nom!))"
        self.navigationItem.setHidesBackButton(true, animated:true)
        self.view.gradienteBackground(colors: (initColor: UIColor(rgb: 0x6A82FB), endColor: UIColor(rgb: 0xFC5C7D)), orientation: .bottomRightTopLeft)
        let menuItems = self.getButtonsParameters()
        let stackMenu = StackMenu(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), configuration: menuItems)
        stackMenu.delegate = self
        self.view.addSubview(stackMenu)
        stackMenu.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                stackMenu.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                stackMenu.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                stackMenu.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                stackMenu.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint(item: stackMenu, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackMenu, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackMenu, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: stackMenu, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        }
        
        
    }
    
    
    @IBAction func logout_btn(_ sender: Any) {
        
        //        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        
        //        self.navigationController?.popToRootViewController(animated: true)
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
            performSegue(withIdentifier: "disconnect", sender: nil)
            
        }
        
    }
    private func getButtonsParameters() -> [ButtonConfiguration<CircleButtonParameters, Any>] {
        
        var parameters = [ButtonConfiguration<CircleButtonParameters, Any>]()
        
        let airquality = getMenuItemConfiguration(imageName: "profile",
                                                  gradient: Gradient(colors: (initColor: UIColor(rgb: 0x11998e), endColor: UIColor(rgb: 0x38ef7d)),
                                                                     orientation: GradientOrientation.bottomRightTopLeft),
                                                  textMenuItem: "Profile")
        let journey = getMenuItemConfiguration(imageName: "camping",
                                               gradient: Gradient(colors: (initColor: UIColor(rgb: 0x800080), endColor: UIColor(rgb: 0xffc0cb)), orientation: GradientOrientation.bottomRightTopLeft),
                                               textMenuItem: "Camping")
        let lineStatus = getMenuItemConfiguration(imageName: "linestatus",
                                                  gradient: Gradient(colors: (initColor: UIColor(rgb: 0xfc4a1a), endColor: UIColor(rgb: 0xf7b733)), orientation: GradientOrientation.bottomRightTopLeft),
                                                  textMenuItem: "Articles")
        
        let tubeLines = getMenuItemConfiguration(imageName: "tubelines",
                                                 gradient: Gradient(colors: (initColor: UIColor(rgb: 0x1c92d2), endColor: UIColor(rgb: 0xf2fcfe)), orientation: GradientOrientation.bottomRightTopLeft),
                                                 textMenuItem: "Mes participations")
//        let bike = getMenuItemConfiguration(imageName: "bike",
//                                            gradient: Gradient(colors: (initColor: UIColor(rgb: 0x2c3e50), endColor: UIColor(rgb: 0x4CA1AF)),
//                                                               orientation: GradientOrientation.bottomRightTopLeft),
//                                            textMenuItem: "Bikes")
//        let bus = getMenuItemConfiguration(imageName: "bus",
//                                           gradient: Gradient(colors: (initColor: UIColor(rgb: 0x834d9b), endColor: UIColor(rgb: 0xd04ed6)),
//                                                              orientation: GradientOrientation.bottomRightTopLeft),
//                                           textMenuItem: "Bus Stops")
        
        parameters = [airquality, journey, lineStatus, tubeLines]
        return parameters
    }
    
    private func getMenuItemConfiguration(imageName: String, gradient: Gradient, textMenuItem: String) -> buttonConfiguration {
        
        let menuItemConfiguration = ButtonConfiguration<CircleButtonParameters, Any>(resolver: { (type) -> Any in
            switch type {
            case .imageName:
                return imageName
            case .gradient:
                return gradient
            case .textMenuItem:
                return textMenuItem
            }
        })
        return menuItemConfiguration
    }
    
}
extension AcceuilViewController: StackMenuDelegate {
    
    @objc func stackMenu( pressedButtonAtIndex: Int) {
        print("Pressed: \(#function) index: \(pressedButtonAtIndex)")
        if (pressedButtonAtIndex==2){
            performSegue(withIdentifier: "toEvent", sender: nil)
        }
        if (pressedButtonAtIndex==0){
            performSegue(withIdentifier: "toProfile", sender: nil)
        }
        if (pressedButtonAtIndex==1){
            performSegue(withIdentifier: "toArticle", sender: nil)
        }
    }
}

extension UIView {
    
    func gradienteBackground(colors: GradientColors, orientation: GradientOrientation) {
        let gradient = CAGradientLayer()
        
        gradient.colors = [colors.initColor.cgColor, colors.endColor.cgColor]
        gradient.startPoint = orientation.points().startPoint
        gradient.endPoint = orientation.points().endPoint
        gradient.frame = bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}
extension AcceuilViewController: BATabBarControllerDelegate {
    func tabBarController(_ tabBarController: BATabBarController, didSelect: UIViewController) {
        print("Delegate success!");
    }
}
