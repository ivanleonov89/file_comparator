class Differ
  def initialize(arr1, arr2)
    arrays = [arr1, arr2]

    biggest_arr_size = arrays.map(&:size).max
    @data = arrays.map { |arr| fill_to_size(arr, biggest_arr_size) }
    @unresolved_ranges = [0..(biggest_arr_size - 1)]
  end

  def process
    while @unresolved_ranges.any?
      range = @unresolved_ranges.shift
      match_ranges = find_longest_match(range)
      next unless match_ranges.any?

      offset = adjust_matched_ranges(*match_ranges)

      resolve_range(
        range.first..(range.last + offset),
        match_ranges.max_by(&:first),
        offset
      )
      clean_extra_nils
    end

    @data
  end

  private

  def fill_to_size(arr, size)
    arr << nil until arr.size == size

    arr
  end

  def find_longest_match(range)
    data = @data.map { |arr| arr[range] }
    max = []
    current = []

    data.first.each do |item|
      next if item.nil?

      current << item

      if sub_array?(data.last, current)
        max = current.dup if current.size > max.size
      else
        current = []
      end
    end

    data.map { |arr| find_range(arr, max, range.first) }
  end

  def sub_array?(arr, sub_arr)
    return false if sub_arr.size > arr.size

    arr.each_cons(sub_arr.size) { |sect| return true if sect == sub_arr }

    false
  end

  def find_range(arr, sub_arr, offset)
    return if sub_arr.empty?

    i = 0
    arr.each_cons(sub_arr.size) do |sect|
      return (i + offset)..(i + offset + sub_arr.size - 1) if sect == sub_arr

      i += 1
    end

    nil
  end

  def adjust_matched_ranges(range1, range2)
    offset = (range1.first - range2.first).abs

    move_points = if range1.first > range2.first
                    [(range1.last + 1), range2.first]
                  else
                    [range1.first, (range2.last + 1)]
                  end

    @data.each_with_index { |arr, i| arr.insert(move_points[i], *Array.new(offset)) }

    offset
  end

  def resolve_range(unresolved_range, matched_range, offset)
    rest_unresolved = [
      unresolved_range.first..(matched_range.first - 1),
      (matched_range.last + 1)..unresolved_range.last
    ].select { |range| range.size > 1 }

    adjust_unresolved_ranges(matched_range.first, offset)

    @unresolved_ranges.concat(rest_unresolved)
  end

  def adjust_unresolved_ranges(start_index, offset)
    @unresolved_ranges.map! do |range|
      range.first > start_index ? (range.first + offset)..(range.last + offset) : range
    end
  end

  def clean_extra_nils
    (@data.first.size - 1).downto(0) do |i|
      next if @data.any? { |arr| arr[i] }

      @data.each { |arr| arr.delete_at(i) }

      adjust_unresolved_ranges(i, -1)
    end
  end
end
