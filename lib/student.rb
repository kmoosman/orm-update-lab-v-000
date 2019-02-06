require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade)
    @name = name
    @grade = grade
    @id = nil
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER)
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql_insert = <<-SQL
        INSERT INTO students (name, grade) VALUES (?,?)
      SQL

      DB[:conn].execute(sql_insert,self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
   end

   def update
     sql = <<-SQL
        UPDATE students SET name = ?, grade = ? WHERE id = ?
     SQL
     DB[:conn].execute(sql,self.name, self.grade, self.id)
   end

   def create(name:, grade:)
     student = Student.new
     student.name = name
     student.grade = grade

     student.save
     student
   end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
