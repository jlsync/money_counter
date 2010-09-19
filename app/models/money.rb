class Money
  
  # Coin Diameters
  # Ratios are calculated on the basis of
  # https://spreadsheets.google.com/ccc?key=0Ah-CKcIqfz9OdHpmUkxDSlN3SXVZY202cmFKMldlb0E&hl=en&authkey=CNaUhNEM#gid=0
  # 
  # ONE_PENCE = nil
  # TWO_PENCE = nil
  # Currently disregarding the one and two pences
  # FIVE_PENCE has been taken as the base for calculating ratios
  # 
  FIVE_PENCE   = 18.0
  TEN_PENCE    = 24.5
  TWENTY_PENCE = 21.4
  FIFTY_PENCE  = 27.3
  ONE_POUND    = 22.5
  TWO_POUND    = 28.4
  
  
  def initialize(coin_diameters)
    @coin_diameters = coin_diameters
  end
  
  def ones_and_twos_grouping
    percent_variation_allowed = 0.1
    max = @coin_diameters.max
    min = @coin_diameters.min
    
    max_range = (max - (max * percent_variation_allowed))..(max + (max * percent_variation_allowed))
    min_range = (min - (min * percent_variation_allowed))..(min + (min * percent_variation_allowed))

    result = {}
    result[:twos] = 0
    result[:ones] = 0
    @coin_diameters.each do |diameter|

      if max_range.include?(diameter)
        result[:twos] += 1
      elsif min_range.include?(diameter)
        result[:ones] += 1
      end
      
    end
    
    return result if (result[:twos].size + result[:ones].size) == @coin_diameters.size

    # Now catch the edge cases
    @coin_diameters.each do |diameter|
      next if max_range.include?(diameter)
      next if min_range.include?(diameter)
      
      max_diff = max-diameter
      min_diff = min-diameter
      
      if max_diff.abs > min_diff.abs
        result[:twos] += 1
      else
        result[:ones] += 1
      end

    end
    
    return result
  end
  
  def total
    res = ones_and_twos_grouping
    return (res[:twos] * 2) + res[:ones]
  end
  
  # ====================================================
  # = Code below needs fix or a better way of doing it =
  # ====================================================
  def standard_ratios
    [ 
      [FIVE_PENCE/FIVE_PENCE, TEN_PENCE/FIVE_PENCE, TWENTY_PENCE/FIVE_PENCE, FIFTY_PENCE/FIVE_PENCE, ONE_POUND/FIVE_PENCE, TWO_POUND/FIVE_PENCE],
      [FIVE_PENCE/TEN_PENCE, TEN_PENCE/TEN_PENCE, TWENTY_PENCE/TEN_PENCE, FIFTY_PENCE/TEN_PENCE, ONE_POUND/TEN_PENCE, TWO_POUND/TEN_PENCE],
      [FIVE_PENCE/TWENTY_PENCE, TEN_PENCE/TWENTY_PENCE, TWENTY_PENCE/TWENTY_PENCE, FIFTY_PENCE/TWENTY_PENCE, ONE_POUND/TWENTY_PENCE, TWO_POUND/TWENTY_PENCE],
      [FIVE_PENCE/FIFTY_PENCE, TEN_PENCE/FIFTY_PENCE, TWENTY_PENCE/FIFTY_PENCE, FIFTY_PENCE/FIFTY_PENCE, ONE_POUND/FIFTY_PENCE, TWO_POUND/FIFTY_PENCE],
      [FIVE_PENCE/ONE_POUND, TEN_PENCE/ONE_POUND, TWENTY_PENCE/ONE_POUND, FIFTY_PENCE/ONE_POUND, ONE_POUND/ONE_POUND, TWO_POUND/ONE_POUND],
      [FIVE_PENCE/TWO_POUND, TEN_PENCE/TWO_POUND, TWENTY_PENCE/TWO_POUND, FIFTY_PENCE/TWO_POUND, ONE_POUND/TWO_POUND, TWO_POUND/TWO_POUND]
    ]
  end
  
  def coin_ratios
    smallest_coin = @coin_diameters.sort.first
    @coin_diameters.map { |diameter| diameter/smallest_coin }
  end
  
  def determine_differences_with_standard_ratios
    final_differences = {}
  
    standard_ratios.each_with_index do |standard_ratio_array, index|
      final_differences[index] = []
       
      coin_ratios.each do |coin_ratio|
        differences = []
        standard_ratio_array.each do |standard_ratio|
          diff = coin_ratio.abs - standard_ratio
          differences << diff
          # puts "#{coin_ratio} - #{standard_ratio} - #{diff} - #{index}"
        end
        final_differences[index] << min_difference_index(differences)
        puts final_differences.inspect
      end

    end
    return final_differences
  end
  
  def get_closest_match_with_standard_ratios
    min = 1000000 # assign a high value to min to start with
    min_element = 0
    ratio_diff = determine_differences_with_standard_ratios
    ratio_diff.each_pair do |key, values|
      overall_diff = 0
      standard = values.map{ |element_index| standard_ratios[key][element_index] }
      standard.each_with_index do |ratio, index|
        diff = ratio - coin_ratios[index].abs
        overall_diff += diff
      end
      puts overall_diff
      if overall_diff < min
        min = overall_diff
        min_element = key
      end
    end
    return min_element, ratio_diff[min_element]
  end
  
  def min_difference_index(values)
    min = [0, 1000.0] #initialize with index 0 and 1000.0 diff
    values.each_with_index do |value, index|
      min = [index, value] if value.abs < min.last
    end
    return min.first
  end
  
end
