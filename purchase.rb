require 'byebug'

class Purchase

  attr_reader :valid_combinations

  def initialize(budget)
    @budget = budget.to_f
    @valid_combinations = []
  end


  def items
    {
      "The Everything Store" => 12.99,
      "Astrophysics for People in a Hurry" => 8.91,
      "Thinking, Fast and Slow" => 9.99,
      "The Bed of Procrustes" => 11.99,
      "The Innovators" => 13.99,
      "Play Bigger: How Pirates, Dreamers, and Innovators Create and Dominate Markets" => 16.00,
      "After On" => 13.99,
      "Homo Deus" => 17.99,
      "A Universe From Nothing" => 11.99,
      "A Piece of the Sun" => 10.99,
      "An Extraordinary Time: The End of the Postwar Boom and the Return to the Ordinary Economy" => 18.99,
      "The Inevitable" => 13.99
    }
  end


  def item_tuples
    items.to_a
  end


  def item_sum(item_list)
    item_list.reduce(0) { |acc, (name, price)| acc + price }.round(2)
  end


  def combination(items, remaining_items)
    # TODO: There's a better recursive solution that doesn't need to continually append to @valid_combinations instance variable
    current_total = item_sum(items)
    
    remaining_items.each do |next_item|
      if item_sum(items + [next_item]) > @budget
        @valid_combinations << items
        @valid_combinations.uniq!
      else
        combination(
          items + [next_item],
          remaining_items.reject { |x| x == next_item }
        )
      end
    end
  end


  def compute_combinations
    item_tuples.map do |item|
      combination([item], item_tuples.reject {|x| x == item})
    end
  end


  def best_option_by_cost(results = 10)
    @valid_combinations.sort_by { |item_list| item_sum(item_list) }.reverse[0..results]
  end


  def best_option_by_number_of_items(results = 10)
    @valid_combinations.sort_by { |item_list| item_list.length }.reverse[0..results]
  end


  def pretty_print(results = 10, sort_by = :price)
    best_options = (sort_by == :price ? best_option_by_cost(results) : best_option_by_number_of_items(results))

    best_options.each do |result|
      total_price = item_sum(result)
      items = result.map { |name, price| "\"#{name}\" (#{price})" }.join(", ")

      puts "#{total_price} : #{items}"
    end
  end

end


purchases = Purchase.new(30.00)
purchases.compute_combinations

puts "\nBest options by price\n"
purchases.pretty_print(50, :price)

puts "\nBest options by price\n"
purchases.pretty_print(50, :cost)

