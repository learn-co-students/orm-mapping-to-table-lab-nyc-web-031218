class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade)
    @name = name
    @grade = grade
    # @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS
      students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
    SQL
    DB[:conn].execute(sql)

  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE
      students;

    SQL
    DB[:conn].execute(sql)
  end

  def save
    # binding.pry
    sql = <<-SQL
    INSERT INTO
      students (name, grade) VALUES (?, ?);

    SQL
    DB[:conn].execute(sql, self.name , self.grade)
    # binding.pry
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end


  def self.create(hash)
    # binding.pry
    person = hash[:name]
    grade = hash[:grade]
    sql = <<-SQL
    INSERT INTO
      students (name, grade) VALUES (?,?)

    SQL
    DB[:conn].execute(sql, person, grade)
    # binding.pry

     key = DB[:conn].execute("SELECT * FROM students WHERE id = 1")[0]
     Student.new(key[1],key[2])
    # binding.pry
  end




end
