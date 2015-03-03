class Random
  def next
    rand
  end
end

class GeneticAlgorithm
  def initialize(&block)
    instance_eval &block
  end

  def generate(&block)
    if block_given?
      @generate = block
    else
      @generate
    end
  end

  def fitness(&block)
    if block_given?
      @fitness = block
    else
      @fitness
    end
  end

  def mutate(&block)
    if block_given?
      @mutate = block
    else
      @mutate
    end
  end

  def run
    population_size = 30
    population = population_size.times.map do |time|
      @generate.call Random.new
    end

    best = 100.times.reduce(population) do |population, time|
      elite = population.sort_by(&fitness).reverse.first(population_size / 2)

      elite + elite.map { |individual| @mutate.call individual, Random.new }
    end

    best.sort_by(&fitness).reverse.first
  end
end

ga = GeneticAlgorithm.new do
  generate do |random|
    3.times.map do |index|
      (random.next * 75).floor
    end
  end

  fitness do |individual|
    -(150 - individual.inject(&:+)).abs
  end

  mutate do |individual, random|
    clone = individual.clone
    clone[(individual.size * random.next).floor] += (random.next - 0.5) * 10
    clone
  end
end

best = ga.run
puts best.inspect
puts best.inject(&:+)
