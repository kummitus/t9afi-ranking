require 'yaml'

class Tournament
    def initialize(points, army, tournament, position, list, date)
        @tournament = tournament
        @points = points
        @army = army
        @position = position  
        @list = list
        @date = date
    end
end

class Player

    def initialize(name, list)
        @title = name 
        @name = name
        @tournaments = []
        @points = []
        @list = list
    end

    def addScore(score, points, army, tournament, position, list, date)
        @tournaments.push(Tournament.new(points, army, tournament, position, list, date))
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

    def getTournaments
        @tournaments  
    end

    def name
        @name
    end

    def points
        @points
    end

    def list
        @list
    end
end

def calculatePoints(position, max, date, weekend)
    if position == max
        score = 5.0
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
                score = 100.0-((100.0-5.0)/(max-1.0)*(position-1.0))
            end
        else
            new_max = 100-(40-max_players)
            if position == 1
                score = new_max
            else
                score = new_max-(((new_max-5.0)/(max-1.0))*(position-1.0))
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
                players[player["player"]] = Player.new(player["player"], player["list"])
            end
            per_tournament[player["player"]] = Player.new(player["player"], player["list"])
            players[player["player"]].addScore(calculatePoints(index+1, tournament["players"].length, tournament["date"], tournament["weekend"]), player["points"], player["army"], tournament["title"], index+1, player["list"], tournament["date"])
            per_tournament[player["player"]].addScore(calculatePoints(index+1, tournament["players"].length, tournament["date"], tournament["weekend"]), player["points"], player["army"], tournament["title"], index+1, player["list"], tournament["date"])
        end
        results = Array.new
        per_tournament.each_with_index do | (key, player), index|
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
    File.open("_data/scores.yml","w") do |file|
        file.write players.values.to_yaml
   end
end