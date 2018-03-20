
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    # name, grade, and id
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table()
    sql =  <<-SQL
        CREATE TABLE IF NOT EXISTS students (
          id INTEGER PRIMARY KEY,
          name TEXT,
          grade TEXT
        )
      SQL
    DB[:conn].execute(sql)
  end


  def self.drop_table
    sql = <<-SQL
        DROP TABLE students
      SQL
      DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students
      VALUES (?, ?, ?)
    SQL
    DB[:conn].execute(sql, @id, @name, @grade)

    get_id = <<-SQL
      select last_insert_rowid();
    SQL
    @id = DB[:conn].execute(get_id).flatten[0]
  end

  def self.create(s)
    new_student = Student.new(s[:name], s[:grade], nil)
    new_student.save
    new_student
  end
end
