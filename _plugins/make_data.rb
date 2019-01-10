require 'yaml'

class Tournament
    def initialize(points, army, tournament)
        @tournament = tournament
        @points = points
        @army = army
    end
end

class Player

    def initialize(name)
        @name = name
        @tournaments = []
        @points = []
    end

    def addScore(score, points, army, tournament)
        @tournaments.push(Tournament.new(points, army, tournament))
        @points.push(score)
    end

    def getScore
        temp_points = @points.sort {|x,y| y <=> x }
        total_points = 0
        temp_points.each_with_index do |point, index|
            if index > 2
                break
            end
            total_points = point+total_points
        end
        total_points
    end

    def name
        @name
    end

    def points
        @points
    end
end

def calculatePoints(position, max, date, weekend)
    if position == max
        score = 5
    else
        if weekend
            max_players = (1.40 * max).to_i
            if max_players > 100
                max_players = 100
            end
        else
            max_players = max
        end
        if max_players > 39
            if position == 1
                score = 100
            else
                score = 100-((100-5)/(max_players-1)*(position-1))
            end
        else
            new_max = 100-(40-max_players)
            if position == 1
                score = new_max
            else
                score = new_max-(((new_max-5)/(max_players-1))*(position-1))
            end
        end
        if Date.today - Date.parse(date) > 730
            score = 0
        elsif Date.today - Date.parse(date) > 365
            score = score/2
        end        
    end
    score
end

Jekyll::Hooks.register :site, :after_init do |site|
    File.delete('_data/players.yml') if File.exist?('_data/players.yml')
    players = Hash.new
    Dir.foreach('_data/tournaments') do |tournament_file|
        next if tournament_file == '.' or tournament_file == '..' or tournament_file == 'template.yml.sample'
        per_tournament = Hash.new
        tournament = YAML.load_file('_data/tournaments/' + tournament_file)
        tournament["players"].each_with_index do |player, index|
            if !players.key?(player["player"])
                players[player["player"]] = Player.new(player["player"])
                per_tournament[player["player"]] = Player.new(player["player"])
            end
            players[player["player"]].addScore(calculatePoints(index+1, tournament["players"].length, tournament["date"], tournament["weekend"]), player["points"], player["army"], tournament["title"])
            per_tournament[player["player"]].addScore(calculatePoints(index+1, tournament["players"].length, tournament["date"], tournament["weekend"]), player["points"], player["army"], tournament["title"])
        end
        results = Array.new
        puts per_tournament
        per_tournament.values.each_with_index do | player, index|
            results.push({"player"=>player.name, "points"=>player.getScore})
        end
        results = results.sort_by { |k| k["points"] }.reverse
        File.open("_data/test/" + tournament["title"] + ".yml","w") do |file|
            file.write results.to_yaml
        end 
    end

    results = Array.new
    players.values.each_with_index do | player, index|
        results.push({"player"=>player.name, "points"=>player.getScore})
    end
    results = results.sort_by { |k| k["points"] }.reverse
    File.open("_data/players.yml","w") do |file|
        file.write results.to_yaml
   end 
end