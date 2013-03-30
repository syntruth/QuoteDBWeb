class Quote
  include MongoMapper::Document
  
  key :nick,  String, :null => false
  key :quote, String, :null => false
    
  timestamps!

  auto_increment!

  def self.search(opts={})
    term  = opts[:term]
    limit = opts[:number].to_i
    popts = {
      :per_page => (limit.zero? ? 20 : limit),
      :page     => opts[:page]
    }

    return [] if term.empty?

    return self.order(:id2).where(:quote => /#{term}/i).paginate popts
  end

  def self.random(opts={})
    term   = opts[:term]        || ''
    number = opts[:number].to_i || 1
    number = 20 if number > 20
    number = 1  if number < 0

    if term.empty?
      results = []
      count   = self.count
      seen    = []

      number.times do
        quote = self.where(:id2.ne => seen).offset(rand(count)).first

        break if quote.nil?

        results.push quote
        seen.push    quote.id
      end

      return results
    else
      return self._random_with_term term, number
    end

  end

  def self._random_with_term(term, number)
    quotes  = self.where(:quote => /#{term}/i).all
    count   = quotes.count

    return quotes if count <= number
  
    return number.times.collect do
      idx    = rand(count)
      count -= 1
      
      quotes.delete_at idx
    end
  end

  def self.stats(sort_by_nick=true)
    sts = {}

    self.all.each do |quote|
      nick       = quote.nick
      sts[nick]  = 0 unless sts.has_key?(nick)
      sts[nick] += 1
    end

    sorted = sts.sort do |q1, q2|
      sort_by_nick ? q1[0] <=> q2[0] : q2[1] <=> q1[1]
    end

    return sorted
  end

  def <=>(other)
    return self.id2 <=> other.id2
  end
end
