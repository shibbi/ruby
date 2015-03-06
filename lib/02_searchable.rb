require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    cols, values = [], []
    params.keys.each { |attr_name| cols << attr_name }
    params.values.each { |value| values << value }

    condition = (cols.map { |col| "#{col} = ?" }).join(' AND ')

    DBConnection.execute2(<<-SQL, values)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{condition}
    SQL
  end
end

class SQLObject
  # Mixin Searchable here...
end
