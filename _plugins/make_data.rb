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

def calculatePoints(position, max, date)
    if max > 39
        if position == 1
            score = 100
        else
            score = (100-position)/(max-1)
        end
    else
        new_max = 100-(40-max)
        if position == 1
            score = new_max
        else
            score = new_max-(((new_max-5)/(max-1))*(position-1))
        end
    end
    if Date.today - Date.parse(date) > 730
        score = 0
    elsif Date.today - Date.parse(date) > 365
        score = score/2
    end
    score
end

Jekyll::Hooks.register :site, :after_init do |site|
    File.delete('_data/players.yml') if File.exist?('_data/players.yml')
    players = Hash.new
    Dir.foreach('_data/tournaments') do |tournament_file|
        next if tournament_file == '.' or tournament_file == '..'
        tournament = YAML.load_file('_data/tournaments/' + tournament_file)
        tournament["players"].each_with_index do |player, index|
            if !players.key?(player["player"])
                players[player["player"]] = Player.new(player["player"])
            end
            players[player["player"]].addScore(calculatePoints(index+1, tournament["players"].length, tournament["date"]), player["points"], player["army"], tournament["title"])
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