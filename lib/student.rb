class Student
  attr_accessor :name, :grade
  attr_reader :id
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def find_latest_id
    sql = <<-SQL
      SELECT id FROM students ORDER BY id DESC LIMIT 1
    SQL

    DB[:conn].execute(sql).flatten[0]
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
    SQL

    DB[:conn].execute(sql, @name, @grade)

    @id = find_latest_id
    
    self
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
  end
end
