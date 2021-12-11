require_relative "utils"

class NanoTest
  def initialize(title)
    @title = title || "aoc nanotest"
  end

  def assert_all(results, solutions)
    puts "Running tests: #{@title} ===>"

    results.zip(solutions).each do |r, s|
      assert_equal(r, s)
    end

    puts "\n"
  end

  def assert_one(res, solution)
    pp "Running #{@title} ===>"
    assert_equal(res, solution)
  end

  def assert_equal(a, b)
    res = a == b ? ".".green : "x".red
    print(res)
  end
end
