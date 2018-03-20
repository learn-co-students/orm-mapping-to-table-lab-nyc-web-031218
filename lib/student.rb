require 'bundler'
Bundler.require

require 'sqlite3'

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  DB = {:conn => SQLite3::Database.new("db/students.db")}


  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade

  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        )
        SQL
    DB[:conn].execute(sql)
  end



  def self.create(hash)
    student = Student.new(hash[:name], hash[:grade])
    student.save
    student

  end


  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)

  end

end

# binding.pry

puts "a"
