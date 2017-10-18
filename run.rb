require_relative 'financial_advisor'


budget = 30.00

puts "\nBudget: $#{budget}"

potential_purchases = FinancialAdvisor.new(budget, "books")

puts "\n\n#### Best Options by Price:\n\n"
potential_purchases.print_best_options(8, :price)

puts "\n\n#### Best Options by Number of Books Purchased:\n\n"
potential_purchases.print_best_options(8, :cost)

puts ?\n

