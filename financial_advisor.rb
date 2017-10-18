class FinancialAdvisor

  attr_reader :valid_purchases

  def initialize(budget, item_type = "items")
    @budget = budget.to_f
    @item_type = item_type
    @valid_purchases = []

    compute_combinations
  end


  def items
    {
      "The Everything Store" => 12.99,
      "Astrophysics for People in a Hurry" => 8.91,
      "Thinking, Fast and Slow" => 9.99,
      "The Bed of Procrustes" => 11.99,
      "The Innovators" => 13.99,
      "Play Bigger: How Pirates, Dreamers, and Innovators Create and Dominate Markets" => 16.00,
      "Homo Deus" => 17.99,
      "A Universe From Nothing" => 11.99,
      "A Piece of the Sun" => 10.99,
      "An Extraordinary Time: The End of the Postwar Boom and the Return to the Ordinary Economy" => 18.99,
      "The Inevitable" => 13.99,
      "End of the Asian Century" => 15.00,
      "The Next America: Boomers, Millennials and the Looming Generational Slowdown" => 11.99
    }
  end


  def item_tuples
    items.to_a
  end


  def item_sum(item_list)
    item_list.reduce(0) { |acc, (name, price)| acc + price }.round(2)
  end


  def combination(items, remaining_items)
    # TODO: There's a better recursive solution that doesn't need to continually append to @valid_purchases instance variable
    current_total = item_sum(items)
    
    remaining_items.each do |next_item|
      if item_sum(items + [next_item]) > @budget
        @valid_purchases << items.sort
        @valid_purchases.uniq!
      else
        combination(
          items + [next_item],
          remaining_items.reject { |x| x == next_item }
        )
      end
    end
  end


  def compute_combinations
    @valid_purchases = []

    item_tuples.map do |item|
      combination([item], item_tuples.reject {|x| x == item})
    end
  end


  def best_options_by_cost(results = 10)
    @valid_purchases.sort_by { |item_list| item_sum(item_list) }.reverse[0..results]
  end


  def best_options_by_number_of_items(results = 10)
    @valid_purchases.sort_by { |item_list| item_list.length }.reverse[0..results]
  end


  def print_best_options(results = 10, sort_by = :price)
    best_options = (sort_by == :price ? best_options_by_cost(results) : best_options_by_number_of_items(results))

    best_options.each do |result|
      total_price = sprintf('%.2f', item_sum(result))
      items       = result.map { |name, price| "\"#{name}\" ($#{price})" }.join(", ")

      puts "$#{total_price} : #{result.length} #{@item_type}   ==>   #{items}"
    end
  end

end

