class Movie < ActiveRecord::Base
  def self.all_ratings
    find(:all, :select => :rating).map(&:rating).uniq
  end
end
