class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id, student.name, student.grade = row
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
        Student.new_from_db(row)
    end

  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = (?)
    SQL

    row = DB[:conn].execute(sql, name)[0]

    new_from_db(row)

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 9
    SQL

    rows = DB[:conn].execute(sql)
    rows.map { |r| new_from_db(r) }

  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students WHERE grade < 12
    SQL

    rows = DB[:conn].execute(sql)
    rows.map { |r| new_from_db(r) }

  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT (?)
    SQL

    rows = DB[:conn].execute(sql, x)
    rows.map { |r| new_from_db(r) }

  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL

    row = DB[:conn].execute(sql)[0]
    new_from_db(row)

  end


  def self.all_students_in_grade_X(x)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = (?)
    SQL

    rows = DB[:conn].execute(sql, x)
    rows.map { |r| new_from_db(r) }

  end

end
