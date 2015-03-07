require_relative '03_associatable'

# Phase IV
module Associatable
  # Remember to go back to 03_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_opts = self.class.assoc_options[through_name]
      source_opts = through_opts.model_class.assoc_options[source_name]
      self_table = self.class.table_name
      through_table = through_opts.table_name
      source_table = source_opts.table_name

      house = DBConnection.execute(<<-SQL, id)
        SELECT
          #{source_table}.*
        FROM
          #{self_table}
        JOIN
          #{through_table}
        ON
          #{through_table}.id = #{through_opts.foreign_key}
        JOIN
          #{source_table}
        ON
          #{source_table}.id = #{source_opts.foreign_key}
        WHERE
          #{self_table}.id = ?
      SQL

      source_opts.model_class.new(house.first)
    end
  end
end
