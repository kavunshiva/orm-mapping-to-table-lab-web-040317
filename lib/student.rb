class Student
  attr_accessor :name, :grade
  attr_reader :id

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      );
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    kill_all_students = <<-SQL
      DROP TABLE students;
    SQL
    DB[:conn].execute(kill_all_students)
  end

  def self.create(student_hash={})
    new_student = Student.new(student_hash[:name], student_hash[:grade])
    new_student.save
    new_student
  end

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def save
    save_student = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(save_student, self.name, self.grade)
    id_query = <<-SQL
      SELECT id FROM students
      ORDER BY id DESC
      LIMIT 1;
    SQL
    @id = DB[:conn].execute(id_query).flatten[0]
  end

end
