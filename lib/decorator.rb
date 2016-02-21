class Decorator
  def self.decorate_diff(arr1, arr2)
    res = []
    arr1.each_with_index do |item, i|
      item2 = arr2[i]

      line = if item == item2
               "  #{item}"
             elsif item.nil?
               "+ #{item2}"
             elsif item2.nil?
               "- #{item}"
             else
               "* #{item}|#{item2}"
             end

      res << "#{i+1}. #{line}"
    end

    res.join("\n")
  end
end
