require "colorize"

puts "start cleaning shm"
puts

count = 0

info = `ipcs -m`.split("\n")
info.each do |i|
  if i =~ /^m\s+(\d+)\s.+$/
    print ".".colorize.fore(:green)
    count += 1

    shm_id = $1

    `ipcrm -m #{shm_id}`
  end
end

puts
puts 
puts "```"
puts `ipcs -m`
puts "```"
puts
puts "finished (#{count} of shm are cleaned)"
