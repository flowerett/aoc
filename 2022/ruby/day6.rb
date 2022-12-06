input = File.read("../inputs/day6").strip

tune = -> data, win {
  win + data.chars.each_cons(win).map(&:uniq).map(&:size).index { |i| i == win }
}

pp tune.(input, 4)
pp tune.(input, 14)
