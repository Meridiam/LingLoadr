require 'csv'

puts "Please enter space-separated paths to experimental CSV files: "
$stdout.flush

experimental_paths = gets

puts "Please enter space-separated paths to filler CSV files: "
$stdout.flush

filler_paths = gets

begin
    experimental_paths.split(/(?<!".)(?<!\\)\s(?!.*")/).map { |path| path.strip.gsub("\\ ", " ").gsub("\"", "") }.each do |experimental|
        CSV.foreach experimental do |row|
            wordi = -1
            stimulus = row[2].split(" ").map do |word| 
                "#{word}@reg#{wordi += 1}"
            end.join(" ")

            if row[4] == "0"
                answer = "Y"
            else
                answer = "N"
            end

            File.open('items.txt', 'a') do |f| 
                f.write("# narwhal #{row[1]} #{row[0]}\n#{stimulus}\n?q#{row[1]}#{row[0]} #{row[3]} #{answer}\n")
            end
        end
    end

    filler_paths.split(/(?<!".)(?<!\\)\s(?!.*")/).map { |path| path.strip.gsub("\\ ", " ").gsub("\"", "") }.each do |filler|
        CSV.foreach filler do |row|
            wordi = -1
            stimulus = row[2].split(" ").map do |word| 
                "#{word}"
            end.join(" ")

            if row[3] == "0"
                answer = "Y"
            else
                answer = "N"
            end

            if row[4] == "practice"
                name = "practice"
            else
                name = "filler"
            end

            File.open('items.txt', 'a') do |f| 
                f.write("# #{name} #{row[0]} -\n#{row[1]}\n?q#{row[0]} #{row[2]} #{answer}\n")
            end
        end
    end
rescue StandardError => e
    puts "Error encountered: #{e}"
end