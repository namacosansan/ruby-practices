

(1..20).each do |i|
  case i % 15
  when 0
    puts "FizzBuzz"
  else
    case i % 5
    when 0
      puts "Buzz"
    else
      case i % 3
      when 0
        puts "Fizz"
      else
        puts i
      end
    end
  end

end
