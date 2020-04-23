//
//  ViewController.swift
//  wpbmi
//
//  Created by Hiroki Imai on 2020/04/20.
//  Copyright © 2020 westieproducts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //  userDefaultsの定義
    var userDefaults = UserDefaults.standard
    
    var weight = 0.0
    var tall = 0.0
    var BMI = ""
    var animeWidthOrigin = 80.0
    var animeWidth = 80.0
    var animeHeight = 200.0
    var manColorOrigin = UIColor.white
    var manColor = UIColor.white
    
    @IBAction func btnImage(_ sender: UISegmentedControl) {
         let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == 0 {
            manImage.image = UIImage(named: "man")
        } else {
            manImage.image = UIImage(named: "woman")
        }
        
    }
    @IBOutlet weak var manImage: UIImageView!
    @IBOutlet weak var inTall: UITextField!
    @IBOutlet weak var inWeight: UITextField!
    @IBAction func btnCalc(_ sender: UIButton) {
        if let inTall = inTall.text {
            tall = atof(inTall)
//            tall = Double(inTall)!
            
        }
        if let inWeight = inWeight.text {
            weight = atof(inWeight)
//            weight = Double(inWeight)!
        }
        if weight != 0 && tall != 0 {
            outText.text = calc(weight,tall)
        }
        //色の変更
        manImage.tintColor = manColor
        //アニメーション
        startBigAnimation(animeWidth)
        
        // userDefaultsに格納したい値
        let bmiData: [Double] = [tall,weight]
        // 配列の保存
        userDefaults.set(bmiData, forKey: "bmiData")
        print("bmiData:\(bmiData)")
    }
    @IBOutlet weak var outBMI: UILabel!
    @IBOutlet weak var outText: UILabel!
    @IBOutlet weak var outWeight: UILabel!
    
    @IBOutlet weak var manView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manColorOrigin = manImage.tintColor
        
        // userDefaultsに保存された値の取得
        guard let bmiData = userDefaults.array(forKey: "bmiData") as? [Double] else {return}
        print("bmiData:\(bmiData)")
        inTall.text = String(bmiData[0])
        inWeight.text = String(bmiData[1])
    }

    //計算
    func calc(_ weight:Double,_ tall:Double) -> String{
            let mTall = tall / 100
            let calBMI = weight / (mTall * mTall)
            outBMI.text = String(format: "%.2f ", calBMI)
        /*
         ≧25～30＞    肥満1度    肥満
         ≧30～35＞    肥満2度
         ≧35～40＞    肥満3度
         ≧40         肥満4度
         ≧18.5～25＞ 普通体重
         ＜18.5      低体重
         */
            switch calBMI {
            case ..<18.5:
                BMI = "低体重"
                animeWidth = animeWidthOrigin * 0.7
                manColor = .gray
            case 18.5..<25:
                BMI = "普通体重"
                animeWidth = animeWidthOrigin
                manColor = manColorOrigin
            case 25..<30:
                BMI = "肥満1度"
                animeWidth = animeWidthOrigin * 1.2
                manColor = .yellow
            case 30..<35:
                BMI = "肥満2度"
                animeWidth = animeWidthOrigin * 1.4
                manColor = .orange
            case 35..<40:
                BMI = "肥満3度"
                animeWidth = animeWidthOrigin * 1.6
                manColor = .red
            case 40...:
                BMI = "肥満4度"
                animeWidth = animeWidthOrigin * 1.8
                manColor = .magenta
            default:
                BMI = "判定不能"
               animeWidth = animeWidthOrigin
                manColor = .lightGray
            }
        
            let calTall = 22 * mTall * mTall
            outWeight.text = String(format: "%.2f ", calTall)
        
        return BMI
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // キーボードを閉じる
        view.endEditing(true)
    }
    //アニメーション
    func startBigAnimation(_ width:Double){
        UIView.animate(withDuration: 1.0, delay: 0.0,  options: .curveEaseOut, animations: {
            self.manView.bounds.size.width = CGFloat(width)
        })
    }
    
}

