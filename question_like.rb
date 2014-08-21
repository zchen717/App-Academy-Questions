require_relative 'questionsdb'
require_relative 'question'

class QuestionLike
  attr_accessor :id, :title, :body, :author_id
  
  def initialize(options = {})
    @id, @user_id, @question_id=
    options.values_at('id', 'user_id', 'question_id')
  end
  
  def self.find_by_id
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      question_likes.id = id
    SQL
    results.empty? ? nil : QuestionLike.new(results.first)
  end
  
  def self.likers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      users 
    JOIN
      question_likes ON users.id = question_likes.user_id
    WHERE
      question_likes.question_id = ?
    SQL
    results.map { |result| QuestionLike.new(result) unless result.nil?} 
  end
  
  def self.num_likes_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(user_id) AS count
    FROM
      question_likes
    WHERE
      question_id = ?
    GROUP BY
      question_id
    SQL
    results.first['count']
  end
  
  def self.liked_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
    questions.*
    FROM
      questions
    JOIN
      question_likes ON questions.id = question_likes.question_id
    WHERE
      question_likes.user_id = ?
    SQL
    results.map { |result| QuestionLike.new(result) unless result.nil?} 
  end
  
  def self.most_liked_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.* 
    FROM
      questions
    JOIN
      question_likes ON questions.id = question_likes.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(*) DESC
    LIMIT ?
    SQL
    results.map { |result| Question.new(result) unless result.nil?}  
  end
end