require_relative 'questionsdb'
class QuestionFollower
  attr_accessor :id, :user_id, :question_id
  
  def initialize(options = {})
    @id, @user_id, @question_id =
      options.values_at('id', 'user_id', 'question_id')
  end
  
  
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_followers
    WHERE
      question_followers.id = ?
    SQL
    result.empty? ? nil : QuestionFollower.new(result.first)
  end
  
  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      users.*
    FROM
      users
    JOIN
      question_followers ON users.id =  question_followers.user_id
    WHERE
      question_id = ? 
    SQL
    results.map { |result| User.new(result) }  
  end
  
  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      questions.*
    FROM
      questions
    JOIN
      question_followers ON questions.id = question_followers.question_id
    WHERE
      user_id = ?
    SQL
    results.map { |result| Question.new(result) unless result.nil?}  
  end
  
  def self.most_followed_questions(n)
    results = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      questions.id, questions.title, questions.body, questions.author_id 
    FROM
      questions
    JOIN
      question_followers ON questions.id = question_followers.question_id
    GROUP BY
      questions.id
    ORDER BY
      COUNT(*) DESC
    LIMIT ?
    SQL
    results.map { |result| Question.new(result) unless result.nil?}  
  end
  
end