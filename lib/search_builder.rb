module SearchBuilder
  def self.included(base)
    base.extend(ClassMethods)
  end

  #def conditions
  #  [conditions_clauses.join(' AND '), *conditions_options]
  #end

  #def conditions_clauses
  #  conditions_parts.map { |condition| condition.first }
  #end

  #def conditions_options
  #  conditions_parts.map { |condition| condition[1..-1] }.flatten
  #end

  def conditions
    methods.grep(/_searchable_conditions$/).map { |m| self.class.merge_conditions(send(m)) }.compact.join(" AND ")
  end


  module ClassMethods
    def searchable_like( *columns )
      self.class_eval do
        columns.each do |column|
          define_method("#{column}_like_searchable_conditions") do
            ["#{self.class.table_name}.#{column} like ?", "%#{self.send(column)}%"] unless self.send(column).blank?
          end
        end
      end
    end

    def searchable_equal( *columns )
      self.class_eval do
        columns.each do |column|
          define_method("#{column}_equal_searchable_conditions") do
            ["#{self.class.table_name}.#{column} = ?", self.send(column)] unless self.send(column).blank?
          end
        end
      end
    end

    def searchable_less_than( *columns )
      self.class_eval do
        columns.each do |column|
          define_method("#{column}_less_than_searchable_conditions") do
            ["#{self.class.table_name}.#{column} < ?", self.send(column)] unless self.send(column).blank?
          end
        end
      end
    end

    def searchable_less_and_equal_than( *columns )
      self.class_eval do
        columns.each do |column|
          define_method("#{column}_less_and_equal_than_searchable_conditions") do
            ["#{self.class.table_name}.#{column} <= ?", self.send(column)] unless self.send(column).blank?
          end
        end
      end
    end

    def searchable_greater_than( *columns )
      self.class_eval do
        columns.each do |column|
          define_method("#{column}_greater_than_searchable_conditions") do
            ["#{self.class.table_name}.#{column} > ?", self.send(column)] unless self.send(column).blank?
          end
        end
      end
    end

    def searchable_greater_and_equal_than( *columns )
      self.class_eval do
        columns.each do |column|
          define_method("#{column}_greater_and_equal_than_searchable_conditions") do
            ["#{self.class.table_name}.#{column} >= ?", self.send(column)] unless self.send(column).blank?
          end
        end
      end
    end

    def date_searchable_between( column, begin_column, end_column)
      self.class_eval do
        # create attr_accessor
        attr_accessor begin_column
        attr_accessor end_column

        define_method("#{column}_between_searchable_conditions") do
          ["#{self.class.table_name}.#{column} BETWEEN ? AND ?", Date.parse(self.send(begin_column)).at_beginning_of_day, Date.parse(self.send(end_column)).end_of_day] unless self.send(begin_column).blank? || self.send(end_column).blank?
        end
      end
    end

    def integer_searchable_between( column, begin_column, end_column)
      self.class_eval do
        # create attr_accessor
        attr_accessor begin_column
        attr_accessor end_column

        define_method("#{column}_between_searchable_conditions") do
          ["#{self.class.table_name}.#{column} BETWEEN ? AND ?", self.send(begin_column).to_i, self.send(end_column).to_i] unless self.send(begin_column).blank? || self.send(end_column).blank?
        end
      end
    end

    def float_searchable_between( column, begin_column, end_column)
      self.class_eval do
        # create attr_accessor
        attr_accessor begin_column
        attr_accessor end_column

        define_method("#{column}_between_searchable_conditions") do
          ["#{self.class.table_name}.#{column} BETWEEN ? AND ?", self.send(begin_column).to_f, self.send(end_column).to_f] unless self.send(begin_column).blank? || self.send(end_column).blank?
        end
      end
    end

  end
end
