class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name, title, salary, boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(multiplier)
    bonus = @salary * multiplier
  end
end

class Manager < Employee
  attr_accessor :employees

  def initialize(name, title, salary, boss, employees)
    super(name, title, salary, boss)
    @employees = []
    employees.each do |single_employee|
      add_employee(single_employee)
    end
  end

  def add_employee(single_employee)
    @employees << single_employee
    single_employee.boss = self
  end

  def bonus(multiplier)
    total_bonus = @salary * multiplier
    @employees.each do |single_employee|
      total_bonus += single_employee.bonus(multiplier)
    end

    return total_bonus - @salary * multiplier if @boss == nil
    total_bonus
  end
end

a = Employee.new("a","basic",5000,nil)
b = Manager.new("b","tier1-manager",7000, nil, [a])
c = Manager.new("c","tier2-manager", 9000, nil, [b])