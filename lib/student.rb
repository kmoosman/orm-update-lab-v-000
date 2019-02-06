require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

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

   def self.create(name, grade)
     student = Student.new(name, grade)
     student.save
     student
   end

  #  def self.new_from_db(row)
  #    id = row[0]
  #    name = row[1]
  #    grade = row[2]
  #    student = self.new(name, grade)
  #    @id = row[0]
  #   #  student.id = id
  #    student
  #  end
  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new(row[1], row[2], row[0])
    student
end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
