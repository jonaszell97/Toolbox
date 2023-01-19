
import Foundation

public enum StatsUtilities { }

// MARK: Distributions

public extension StatsUtilities {
    /// - returns: A linear regression estimator for the given x and y values.
    static func linearRegression(_ xs: [Double], _ ys: [Double]) -> (Double) -> Double {
        assert(xs.count != 0)
        assert(xs.count == ys.count)
        
        let mean_xs = xs.mean!
        let mean_ys = ys.mean!
        
        var product = [Double]()
        for i in 0..<xs.count {
            product.append(ys[i] * xs[i])
        }
        
        let correlation = product.mean!
        let autocorrelation = xs.map { $0*$0 }.mean!
        
        let sum1 = correlation - mean_xs * mean_ys
        let sum2 = autocorrelation - pow(mean_xs, 2)
        let slope = sum1 / sum2
        let intercept = mean_ys - slope * mean_xs
        
        return { x in intercept + slope * x }
    }
}

// MARK: Averages

public extension BinaryFloatingPoint {
    // https://math.stackexchange.com/questions/106700/incremental-averaging
    static func updateRunningMean(meanSoFar: Self, valueCountSoFar: Int, newValue: Self) -> Self {
        meanSoFar + ((newValue - meanSoFar) / (Self(valueCountSoFar) + 1))
    }
}

public extension Array where Element: FloatingPoint {
    /// - returns: The arithmetic mean of the values in this array.
    var mean: Element? {
        guard self.count > 0 else { return nil }
        return self.reduce(Element.zero) { $0 + $1 } / Element(self.count)
    }
    
    /// - returns: The population variance of the values in this array.
    var populationVariance: Element? {
        guard let mean else { return nil }
        return self.reduce(Element.zero) { $0 + ($1-mean)*($1-mean) } / Element(self.count)
    }
    
    /// - returns: The population standard deviation of the values in this array.
    var populationStandardDeviation: Element? {
        guard let populationVariance else { return nil }
        return sqrt(populationVariance)
    }
    
    /// - returns: The sample variance of the values in this array.
    var sampleVariance: Element? {
        guard let mean else { return nil }
        return self.reduce(Element.zero) { $0 + ($1-mean)*($1-mean) } / Element(self.count-1)
    }
    
    /// - returns: The sample standard deviation of the values in this array.
    var sampleStandardDeviation: Element? {
        guard let sampleVariance else { return nil }
        return sqrt(sampleVariance)
    }
}
