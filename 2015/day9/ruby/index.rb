dist = {}
$stdin.readlines.map(&:split).each do |x, to, y, equals, d|
    dist[[x,y].sort] = d.to_i
end

p dist.keys.flatten.uniq
return
p dist.keys.flatten.uniq.permutation.map { |comb|
    comb.each_cons(2).reduce(0) {|s, x| s + dist[x.sort] }
}.sort.rotate(-1).first(2)