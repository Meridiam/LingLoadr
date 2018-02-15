require 'csv'

puts "Please enter comma-separated paths to experimental CSV files:"
$stdout.flush

experimental_paths = gets.chomp

puts "Please enter comma-separated paths to filler CSV files: "
$stdout.flush

filler_paths = gets.chomp

puts "Please enter the experiment name:"
$stdout.flush

experiment_name = gets.chomp

puts "Please enter the indices of the columns that track the following variables, delimited by spaces:\n"
puts "Stimulus number, stimulus condition, stimulus sentence, stimulus question, question answer:\n"

colnums = gets.chomp.split(" ").map { |num| (num.to_i - 1) }

puts "Please enter the indices of the columns that track the following variables, delimited by spaces:\n"
puts "Filler number, filler sentence, filler question, filler answer, practice:\n"

filler_colnums = gets.chomp.split(" ").map { |num| (num.to_i - 1) }

begin
    experimental_paths.split(",").
        map { |path| path.
        gsub("~", ENV['HOME']) }.
            each do |experimental|
                CSV.foreach experimental do |row|
                    wordi = -1
                    stimulus = row[colnums[2]].split(" ").map do |word| 
                        "#{word}@reg#{wordi += 1}"
                    end.join(" ")

                    if row[colnums[4]] == "0"
                        answer = "Y"
                    else
                        answer = "N"
                    end

                    File.open('items.txt', 'a:UTF-8') do |f| 
                        f.write("# #{experiment_name} #{row[colnums[0]]} #{row[colnums[1]]}\n#{stimulus}\n?q#{row[colnums[0]]}#{row[colnums[1]]} #{row[colnums[3]]} #{answer}\n")
                    end
                end
            end

    filler_paths.split(",").
        map { |path| path.
        gsub("~", ENV['HOME']) }.
            each do |filler|
                CSV.foreach filler do |row|
                    wordi = -1
                    stimulus = row[filler_colnums[1]].split(" ").map do |word| 
                        "#{word}"
                    end.join(" ")

                    if row[filler_colnums[3]] == "0"
                        answer = "Y"
                    else
                        answer = "N"
                    end

                    if row[filler_colnums[4]] == "practice"
                        name = "practice"
                    else
                        name = "filler"
                    end

                    File.open('items.txt', 'a:UTF-8') do |f| 
                        f.write("# #{experiment_name} #{row[filler_colnums[0]]} -\n#{row[filler_colnums[2]]}\n?q#{row[filler_colnums[0]]} #{row[filler_colnums[2]]} #{answer}\n")
                    end
                end
            end
rescue StandardError => e
    puts "Error encountered: #{e}"
end