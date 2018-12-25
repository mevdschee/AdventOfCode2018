def read_units(filename)
  lines = IO.read(filename).split("\n\n").map { |lines| lines.split("\n") }
  re1 = /(\d+) units each with (\d+) hit points( \([^\)]+\))? with an attack that does (\d+) ([a-z]+) damage at initiative (\d+)/
  re2 = /(weak|immune) to ([^;\)]+)/
  units = { immune_system: {}, infection: {} }
  units.keys.each_with_index do |army, i|
    lines[i].each_with_index do |line, j|
      unit_count, hit_points, substr, attack_damage, attack_type, initiative = line.scan(re1).to_a[0]
      next if unit_count.nil?

      weaknesses = Hash.new(false)
      immunities = Hash.new(false)
      unless substr.nil?
        substr.scan(re2).to_a.each do |type, list|
          case type
          when 'weak'
            list.split(', ').each do |weakness|
              weaknesses[weakness] = true
            end
          when 'immune'
            list.split(', ').each do |immunity|
              immunities[immunity] = true
            end
            end
        end
      end
      units[army][j] = {
        unit_count: unit_count.to_i,
        hit_points: hit_points.to_i,
        weaknesses: weaknesses,
        immunities: immunities,
        attack_damage: attack_damage.to_i,
        attack_type: attack_type,
        initiative: initiative.to_i
      }
    end
  end
  units
end

def effective_power(units, army, group)
  unit_count = units[army][group][:unit_count]
  attack_damage = units[army][group][:attack_damage]
  unit_count * attack_damage
end

def remove_empty_groups(units)
  units.each do |_, groups|
    groups.reject! do |_, group|
      group[:unit_count] == 0
    end
  end
end

def damage(units, army1, group1, army2, group2)
  damage = effective_power(units, army1, group1)
  attack_type = units[army1][group1][:attack_type]
  is_immune = units[army2][group2][:immunities][attack_type]
  is_weak = units[army2][group2][:weaknesses][attack_type]
  damage *= 0 if is_immune
  damage *= 2 if is_weak
  damage
end

def other_army(units, army1)
  i = units.keys.index(army1)
  l = units.keys.length
  units.keys[(i + 1) % l]
end

def target_selection(units)
  fights = []
  units.keys.each do |army1|
    army2 = other_army(units, army1)
    defenders = units[army2].keys
    attackers = units[army1].keys.sort_by do |group1|
      e = effective_power(units, army1, group1)
      i = units[army1][group1][:initiative]
      [-e, -i]
    end
    attackers.each do |group1|
      damages = defenders.map do |group2|
        [group2, damage(units, army1, group1, army2, group2)]
      end.to_h
      group2 = defenders.max_by do |group2|
        d = damages[group2]
        e = effective_power(units, army2, group2)
        i = units[army2][group2][:initiative]
        [d, e, i]
      end
      next if damages[group2] == 0 || group2.nil?

      defenders.delete(group2)

      fights << [army1, group1, army2, group2]
    end
  end
  fights
end

def attacking(units, fights)
  total_kills = 0
  fights.sort_by! { |army1, group1, _, _, _| -units[army1][group1][:initiative] }
  fights.each do |army1, group1, army2, group2|
    attacker = units[army1][group1]
    defender = units[army2][group2]
    next if attacker[:unit_count] == 0

    damage = damage(units, army1, group1, army2, group2)
    kills = damage / defender[:hit_points]
    kills = defender[:unit_count] if kills > defender[:unit_count]
    total_kills += kills

    defender[:unit_count] -= kills
  end
  total_kills
end

units = {}
boost = 0
loop do
  units = read_units('input')
  units[:immune_system].each { |_, v| v[:attack_damage] += boost }
  until units.values.map(&:count).min == 0
    fights = target_selection(units)
    kills = attacking(units, fights)
    break if kills == 0

    remove_empty_groups(units)
  end
  break if units[:infection].count == 0

  boost += 1
end

puts units.values.flatten.map(&:values).flatten.reduce(0) { |sum, v| sum += v[:unit_count] }
