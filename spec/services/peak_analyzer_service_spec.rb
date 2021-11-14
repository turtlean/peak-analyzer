require 'rails_helper'

class PeakAnalyzerServiceTest < ActiveSupport::TestCase
  describe "Z-Score" do
    it "raises error when standard deviation is 0" do
      expect {
        PeakAnalyzerService.zscore(1, 1, 0)
      }.to raise_error(ZeroDivisionError)
    end
  end

  describe "Compute Peaks" do
    it "returns empty for empty array" do
      assert PeakAnalyzerService.compute_peaks([]) == []
    end

    it "returns [0] when there's only one element" do
      assert PeakAnalyzerService.compute_peaks([1.1]) == [0]
    end
  
    it "returns array of 0's when standard deviation is zero" do
      assert PeakAnalyzerService.compute_peaks([3, 3, 3]) == [0, 0, 0]
    end

    it "returns 1 for values with z-score above the threshold and 0 otherwise" do
      # Example from PDF description
      values = [1,1.1,0.9,1,1,1.2,2.5,2.3,2.4,1.1,0.8,1.2,1]

      assert PeakAnalyzerService.compute_peaks(values, 1) == [0,0,0,0,0,0,1,1,1,0,0,0,0]
    end

    it "returns 0 when z-score is the same as threshold" do
      values = [1, 2, 3]
      # mean = 2
      # stddev (1 degree of freedom )= 1 
      # z-scores = [-1, 0, 1]

      assert PeakAnalyzerService.compute_peaks(values, 1) == [0, 0, 0]
    end

    it "computes peaks for larger example" do
      # Example from Google Spreadsheet
      values = [1,2,1,0,1,2,1,8,9,8,1,2,0,2,1,2,3,1,2,0,8,9,2,0,3,0,2,1,2,3,8,10,2,1,2,3,0,1,2,1,2,7,6,9,1,2,0,1,2,1,
        0,2,1,2,3,10,12,1,1,2,3,0,1,2,1,2,7,7,9,1,2,0,1,2,1,2,1,3,0,2,3,1,1,2,3,10,9,12,0,2,3,1,2,0,1,7,11,0,1,2,
        2,1,3,0,2,2,9,7,2,3,1,2,9,8,2,3,1,2,0,1,2,3,0,10,9,1,2,1,0,1,2,1,8,9,8,1,2,0,2,1,2,1,14,10,0,1,1,2,0,3]

      expected = [0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0]

      assert PeakAnalyzerService.compute_peaks(values, 0.9) == expected
    end
  end
end
