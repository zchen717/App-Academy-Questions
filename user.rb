require_relative 'questionsdb'
require_relative 'question'
require_relative 'question_follower'

class User
  attr_accessor :id, :fname, :lname
    
  def initialize(options = {})
    @id, @fname, @lname =
    options.values_at('id', 'fname', 'lname')
  end
  
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
    SQL
    results.empty? ? nil : User.new(results.first) ##what if the id not exit
  end
  
  def self.find_by_name(fname, lname)
    results = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND lname = ?
    SQL
    results.empty? ? nil : User.new(results.first) 
  end
  
  def authored_questions
    Question.find_by_author_id(@id)
  end
  
  def authored_replies
    Reply.find_by_user_id(@id)
  end
  
  def followed_questions
    QuestionFollower.followed_questions_for_user_id(@id)
  end
  
  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
  
  def average_karma
    results = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      COUNT(question_likes.question_id) /
      CAST( COUNT(DISTINCT (questions.id)) AS FLOAT) AS average
    FROM
      questions
    LEFT OUTER JOIN
      question_likes ON questions.id = question_likes.question_id
    WHERE
      questions.author_id = ?
  SQL
    results.first['average']
  end
  
  def save
    if self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO
          users (fname, lname)
        VALUES
          (? , ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
        UPDATE 
         users 
        SET
        fname = ?, lname = ?
      SQL
    end
  end
  
end