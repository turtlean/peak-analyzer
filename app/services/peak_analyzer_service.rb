module PeakAnalyzerService 
  def self.compute_peaks(array, threshold = 1)
    return [] if array.empty?
    return [0] if array.length == 1
    return array.map { 0 } if array.all? { |v| v == array[0] }

    numo_array = Numo::DFloat[*array]
    mean = numo_array.mean
    # Numo::DFloat computes stddev with one degree of freedom (a.k.a divides total sum by (N-1) )
    # https://github.com/ruby-numo/numo-narray/blob/4ea3796527992cbeebc3d7271ced12e92e72af65/ext/numo/narray/numo/types/real_accum.h#L151
    std = numo_array.stddev
    mapper = lambda { |v| self.zscore(v, mean, std) > threshold ? 1 : 0 }
    (numo_array.map { |v| mapper.call(v) }).to_a
  end

  def self.zscore(value, mean, std)
    return (value-mean) / std
  end
end
