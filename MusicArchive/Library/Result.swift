// Copyright (c) 2020 Joshua Escribano-Fontanet

extension Result {
    var isSuccess: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }

    var success: Success? {
        if case let .success(value) = self {
            return value
        } else {
            return nil
        }
    }

    var isFailure: Bool {
        if case .failure = self {
            return true
        } else {
            return false
        }
    }

    var failure: Failure? {
        if case let .failure(failure) = self {
            return failure
        } else {
            return nil
        }
    }
}
