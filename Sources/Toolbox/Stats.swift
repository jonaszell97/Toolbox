
import Foundation

/// This type serves as a namespace for Statistics-related utility functions.
public enum StatsToolbox { }

// MARK: Distributions

public extension StatsToolbox {
    /// Determine a linear regression estimator for the given data sample.
    ///
    /// - Parameters:
    ///   - xs: The sampled x values.
    ///   - ys: The sampled y values.
    /// - Returns: A linear regression estimator for the given x and y values.
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
    
    /// Calculate the value of a normal distribution.
    ///
    /// - Returns: The value of a normal distribution with the average value `mean` and standard deviation `std` at point `x`.
    static func normalDistribution(_ x: Double, mean: Double, std: Double) -> Double {
        let f1 = 1.0/(std*sqrt(2*Double.pi))
        let ex = -0.5 * pow((x - mean) / std, 2)
        return f1 * exp(ex)
    }
    
    /// Calculate the value of the cumulative distribution function of a normal distribution.
    ///
    /// - Returns: The value of the cumulative distribution function of a normal distribution with the average value `mean` and standard deviation `std` at point `x`.
    static func normalDistributionCdf(_ x: Double, mean: Double, std: Double) -> Double {
        0.5 * erfc(((mean - x)/std) * sqrt(0.5))
    }
}

// MARK: Averages

public extension BinaryFloatingPoint {
    // https://math.stackexchange.com/questions/106700/incremental-averaging
    /// Update a running average with a new value.
    static func updateRunningMean(meanSoFar: Self, valueCountSoFar: Int, newValue: Self) -> Self {
        meanSoFar + ((newValue - meanSoFar) / (Self(valueCountSoFar) + 1))
    }
}

public extension Array where Element: FloatingPoint {
    /// - Returns: The arithmetic mean of the values in this array.
    var mean: Element? {
        guard self.count > 0 else { return nil }
        return self.reduce(Element.zero) { $0 + $1 } / Element(self.count)
    }
    
    /// - Returns: The population variance of the values in this array.
    var populationVariance: Element? {
        guard let mean else { return nil }
        return self.reduce(Element.zero) { $0 + ($1-mean)*($1-mean) } / Element(self.count)
    }
    
    /// - Returns: The population standard deviation of the values in this array.
    var populationStandardDeviation: Element? {
        guard let populationVariance else { return nil }
        return sqrt(populationVariance)
    }
    
    /// - Returns: The sample variance of the values in this array.
    var sampleVariance: Element? {
        guard let mean else { return nil }
        return self.reduce(Element.zero) { $0 + ($1-mean)*($1-mean) } / Element(self.count-1)
    }
    
    /// - Returns: The sample standard deviation of the values in this array.
    var sampleStandardDeviation: Element? {
        guard let sampleVariance else { return nil }
        return sqrt(sampleVariance)
    }
}
