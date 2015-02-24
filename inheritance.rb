require 'byebug'

class Employee
  attr_reader :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name, @title, @salary, @boss = name, title, salary, boss
  end

  def total_salaries
    @salary
  end

  def bonus(multiplier)
    @salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees

  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = employees
  end

  def total_salaries
    total = @salary
    @employees.each do |employee|
      # debugger
      total += employee.total_salaries
    end

    total
  end

  def bonus(multiplier)
    multiplier * (total_salaries - @salary)
  end
end
