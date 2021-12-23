require_relative "utils"

class NanoTest
  def initialize(title = nil)
    @title = title || "test"
  end

  def assert_all(results, solutions, title = nil)
    puts "Running tests: #{title || @title} ===>"

    results.zip(solutions).each do |r, s|
      assert_equal(r, s)
    end

    puts "\n"
  end

  def assert_one(res, solution, title = nil)
    pp "Running #{title || @title} ===>"
    assert_equal(res, solution)
  end

  def assert_equal(a, b)
    res = a == b ? ".".green : "x".red
    print(res)
  end
end
