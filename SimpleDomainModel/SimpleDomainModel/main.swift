//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    public func convert(_ to: String) -> Money {
        let givenAmount = Double(self.amount)
        var convertedAmount: Double
        if (self.currency == "USD") {
            if (to == "GBP") {
                convertedAmount = givenAmount * (1.0 / 2.0)
            } else if (to == "EUR") {
                convertedAmount = givenAmount * (3.0 / 2.0)
            } else { // USD to CAN
                convertedAmount = givenAmount * (5.0 / 4.0)
            }
        } else if (self.currency == "GBP") {
            if (to == "USD") {
                convertedAmount = givenAmount * 2.0
            } else if (to == "EUR") {
                convertedAmount = givenAmount * 3.0
            } else { // GBP to CAN
                convertedAmount = givenAmount * (5.0 / 2.0)
            }
        } else if (self.currency == "EUR") {
            if (to == "GBP") {
                convertedAmount = givenAmount * (1.0 / 3.0)
            } else if (to == "USD") {
                convertedAmount = givenAmount * (2.0 / 3.0)
            } else { // EUR to CAN
                convertedAmount = givenAmount * (5.0 / 6.0)
            }
        } else { // CAN
            if (to == "GBP") {
                convertedAmount = givenAmount * (5.0 / 2.0)
            } else if (to == "EUR") {
                convertedAmount = givenAmount * (6.0 / 5.0)
            } else { // CAN to USD
                convertedAmount = givenAmount * (4.0 / 5.0)
            }
        }
        return Money(amount: Int(convertedAmount), currency: to)
    }
    // Adds money and returns the sum of the passed in currency
    public func add(_ to: Money) -> Money {
        if (to.currency != self.currency) {
            let convertedMoney = self.convert(to.currency)
            return Money(amount: to.amount + convertedMoney.amount, currency: to.currency)
        }
        return Money(amount: self.amount + to.amount, currency: to.currency)
    }
    
    // Subtracts money and returns the difference of the passed in currency
    public func subtract(_ from: Money) -> Money {
        if (from.currency != self.currency) {
            let convertedMoney = self.convert(from.currency)
            return Money(amount: from.amount - convertedMoney.amount, currency: from.currency)
        }
        return Money(amount: self.amount - from.amount, currency: from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
        return
    }
    
    // Calculate the income of a person based on an hourly rate or salary
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let rate):
            return Int(Double(hours) * rate)
        case .Salary(let money):
            return money
        }
    }
    
    // Gives a raise based on the passed amount
    open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(let rate):
            self.type = .Hourly(amt + rate)
        case .Salary(let money):
            self.type = .Salary(Int(amt + Double(money)))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    // Assigns a person a job
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { return self._job }
        set(value) {
            if (self.age >= 16) {
                self._job = value
            }
        }
    }
    
    // Assign a person a spouse if both are at least 18 ad do not currenctly have a spouse
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return self._spouse }
        set(value) {
            if self.age >= 18 {
                self._spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job) spouse:\(self.spouse)]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members.append(spouse1)
            self.members.append(spouse2)
        }
    }
    
    // Checks to see if a family can have a child. If so, give them a new child with age 0
    open func haveChild(_ child: Person) -> Bool {
        var haveChild = false;
        for i in 0...(members.count - 1) {
            if members[i].age >= 21 {
                haveChild = true;
            }
        }
        if (haveChild) {
            let newChild = child;
            newChild.age = 0;
            self.members.append(newChild)
        }
        return haveChild
    }
    
    // Adds the income of the faily members and returns it
    open func householdIncome() -> Int {
        var totalIncome = 0
        for i in 0...(members.count - 1) {
            if members[i]._job != nil {
                totalIncome += members[i]._job!.calculateIncome(2000)
            }
        }
        return totalIncome
    }
}






