//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Joan Paredes on 10/8/20.
//

import UIKit

final class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    
    // Resultado
    @IBOutlet weak var resultadoLabel: UILabel!
    
    //Numbers
  
    
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    // Operators
    
    @IBOutlet weak var operatorsAC: UIButton!
    @IBOutlet weak var operatorsPlusMinus: UIButton!
    @IBOutlet weak var operatorsPercent: UIButton!
    @IBOutlet weak var operatorsResult: UIButton!
    @IBOutlet weak var operatorsAddition: UIButton!
    @IBOutlet weak var operatorsSubstraction: UIButton!
    @IBOutlet weak var operatorsMultiplication: UIButton!
    @IBOutlet weak var operatorsDivision: UIButton!
    
    //MARK: - Variables
    
    private var total: Double = 0                        //total
    private var temp: Double = 0                         //Valor por pantalla
    private var operating = false                        //Indica si se ha seleccionado un operador
    private var decimal = false                          //Indica si el valor es decimal
    private var operation:OperationType = .none          //Operacion Actual
    
    
    //MARK: - Constante
    
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let kTotal = "total"
   
    
    private enum OperationType{
        case none, addition, substraccion, multiplication, division, percent
    }
    
    //Formateo de valores auxiliar
    
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    //Formateo de valores por pantalla por defecto
    
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    //  Formateo de valores por pantalla en formato cientifico
    
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    //MARK: - Initializacion
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
              
        total = UserDefaults.standard.double(forKey: kTotal)
              
        result()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        //UI Button
        
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        
        operatorsAC.round()
        operatorsPlusMinus.round()
        operatorsPercent.round()
        operatorsResult.round()
        operatorsAddition.round()
        operatorsSubstraction.round()
        operatorsMultiplication.round()
        operatorsDivision.round()
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        result()
    }
    
    //MARK: - Button Action
    
    @IBAction func operatorACAction(_ sender: UIButton) {
        clear()
        sender.shine()
    }
    
    @IBAction func operatorsPlusMinusAction(_ sender: UIButton) {
        temp = temp * (-1)
        resultadoLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        sender.shine()
    }
    @IBAction func operatorsPercentAction(_ sender: UIButton) {
        
        if operation != .percent {
            result()
        }
        operating = true
        operation = .percent
        result()
        sender.shine()
    }
    
    @IBAction func operatorsResultAction(_ sender: UIButton) {
        
        result()
        sender.shine()
    }
    
    @IBAction func operatorsAdditionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .addition
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operatorsSubstractionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .substraccion
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operatorsMultiplicationAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .multiplication
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operatorsDivisionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operating = true
        operation = .division
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        if resultadoLabel.text?.contains(kDecimalSeparator) ?? false || (!operating && currentTemp.count >= kMaxLength) {
            return
        }
        resultadoLabel.text = resultadoLabel.text! + kDecimalSeparator
        decimal = true
        selectVisualOperation()
        sender.shine()
    }
    @IBAction func numbersAction(_ sender: UIButton) {
        operatorsAC.setTitle("C", for: .normal)
        
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temp))!
        
        if !operating && currentTemp.count >= kMaxLength{
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temp))!
        
        //Hemos seleccionado una operación
        if operating{
            total = total == 0 ? temp: total
            resultadoLabel.text = ""
            currentTemp = ""
            operating = false
        }
        
        //Seleccion Decimales
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temp = Double(currentTemp + String(number))!
        resultadoLabel.text = printFormatter.string(from: NSNumber(value: temp))
        
        selectVisualOperation()
        
        sender.shine()
    }
    
    //Limpia los valores
    private func clear(){
        if operation == .none{
            total = 0
        }
        operation = .none
        operatorsAC.setTitle("AC", for: .normal)
        if temp != 0 {
            temp = 0
            resultadoLabel.text = "0"
        }else{
            total = 0
            result()
        }
    }
    
    //Obtiene el resultado final
    private func result(){
        switch operation {
        case .none:
            //no hacemos nada
            break
        case .addition:
            total = total + temp
            break
        case .substraccion:
            total = total - temp
            break
        case .multiplication:
            total = total * temp
            break
        case .division:
            total = total / temp
            break
        case .percent:
            temp = temp / 100
            total = temp
            break
            
        }
        
        //formateo en pantalla
        
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
                    resultadoLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
                    resultadoLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none
        selectVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        
        print("TOTAL:\(total)")
    }
    
    //Muestra de forma visual la operacion seleccionada
    
    private func selectVisualOperation(){
        if !operating{
            //no estamos operando
            operatorsAddition.selectOperation(false)
            operatorsSubstraction.selectOperation(false)
            operatorsMultiplication.selectOperation(false)
            operatorsDivision.selectOperation(false)
        }else{
            switch operation{
            
            case .none, .percent:
                operatorsAddition.selectOperation(false)
                operatorsSubstraction.selectOperation(false)
                operatorsMultiplication.selectOperation(false)
                operatorsDivision.selectOperation(false)
                break
            case .addition:
                operatorsAddition.selectOperation(false)
                operatorsSubstraction.selectOperation(false)
                operatorsMultiplication.selectOperation(false)
                operatorsDivision.selectOperation(false)
                break
            case .substraccion:
                operatorsAddition.selectOperation(false)
                operatorsSubstraction.selectOperation(false)
                operatorsMultiplication.selectOperation(false)
                operatorsDivision.selectOperation(false)
                break
            case .multiplication:
                operatorsAddition.selectOperation(false)
                operatorsSubstraction.selectOperation(false)
                operatorsMultiplication.selectOperation(false)
                operatorsDivision.selectOperation(false)
                break
            case .division:
                operatorsAddition.selectOperation(false)
                operatorsSubstraction.selectOperation(false)
                operatorsMultiplication.selectOperation(false)
                operatorsDivision.selectOperation(false)
                break
           
                
            }
        }
    }
}
