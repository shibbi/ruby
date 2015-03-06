require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    data = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name};
    SQL

    data.first.map(&:to_sym)
  end

  def self.finalize!
    columns.each do |column|
      define_method(column) { attributes[column] }
      define_method("#{column}=") { |value| attributes[column] = value }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  def self.all
    data = DBConnection.execute(<<-SQL)
      SELECT
        *
      FROM
        #{table_name};
    SQL

    parse_all(data)
  end

  def self.parse_all(results)
    results.map { |value| new(value) }
  end

  def self.find(id)
    data = DBConnection.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?;
    SQL

    data.empty? ? nil : new(data.first)
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      unless self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end

      send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}

    @attributes
  end

  def attribute_values
    self.class.columns.map { |column| send(column) }
  end

  def insert
    cols = self.class.columns[1..-1]
    col_names = cols.join(',')
    question_marks = (['?'] * cols.length).join(',')
    args = attribute_values[1..-1]

    DBConnection.execute(<<-SQL, *args)
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks});
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = self.class.columns[1..-1]
    cols = (col_names.map { |col| "#{col} = ?" }).join(',')
    args = attribute_values[1..-1] + [attribute_values[0]]

    DBConnection.execute(<<-SQL, *args)
      UPDATE
        #{self.class.table_name}
      SET
        #{cols}
      WHERE
        id = ?
    SQL
  end

  def save
    id ? update : insert
  end
end
