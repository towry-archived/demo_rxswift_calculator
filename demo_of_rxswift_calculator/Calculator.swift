
enum CalculatorAction {
    case append(String)
    case clear
    case changeSign
    case operation(Operation)
    case equal
    case percent
}

enum Operation {
    case addition
    case subtraction
    case multiplication
    case division
}

enum CalculatorState {
    case oneOperand(operand: Double, screen: String)
    case operandAndOperator(operand: Double, op: Operation, screen: String)
}

extension CalculatorState {
    static var initialState: CalculatorState {
        return oneOperand(operand: 0.0, screen: "0")
    }

    static func reduce(state: CalculatorState, _ action: CalculatorAction) -> CalculatorState {
        switch action {
            case .clear:
                return CalculatorState.initialState
            case .append(let num):
                let transform: (String) -> String = { s in
                    s == "0" ? String(num) : s + String(num)
                }
                switch state {
                    case let .oneOperand(operand, screen):
                        return .oneOperand(operand: operand, screen: transform(screen))
                    case let .operandAndOperator(operand, op, screen):
                        return .operandAndOperator(operand: operand, op: op, screen: transform(screen))
                }
            case .changeSign:
                // pass
                return state
            case .operation(let op):
                switch state {
                    case .oneOperand(_, let screen):
                        // we have a operator now.
                        return .operandAndOperator(operand: Double(screen) ?? 0.0, op: op, screen: "0")
                    case let .operandAndOperator(operand, op, screen):
                        // perform and change op
                        return .operandAndOperator(operand: op.perform(lhs: operand, rhs: Double(screen) ?? 0.0), op: op, screen: "0")
                }
            case .equal:
                switch state {
                    case .operandAndOperator(let operand, let op, let screen):
                        // perform and return the result state.
                        let result = op.perform(lhs: operand, rhs: Double(screen) ?? 0.0)
                        return .oneOperand(operand: result, screen: String(result))
                    default:
                        return state
                }
            default:
                // invalid
                return state
        }
    }
    
    var screen: String {
        switch self {
            case let .oneOperand(_, screen):
                return screen
            case let .operandAndOperator(_, _, screen):
                return screen
        }
    }
}

extension Operation {
    func perform(lhs: Double, rhs: Double) -> Double {
        switch self {
            case .addition:
                return lhs + rhs
            case .subtraction:
                return lhs - rhs
            case .multiplication:
                return lhs * rhs
            case .division:
                return lhs / rhs
        }
    }
}
