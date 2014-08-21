require_relative 'questionsdb'

class Reply
  attr_accessor :id, :question_id, :user_id, :parent_id, :body
  def initialize(options = {})
    @id, @question_id, @user_id, @parent_id, @body =
    options.values_at('id', 'question_id', 'user_id', 'parent_id', 'body')
  end
  
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies
    WHERE
      id = ?
    SQL
    results.empty? ? nil : Reply.new(results.first) 
  end
  
  def self.find_by_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    results.each { |result| Reply.new(result) unless result.nil?}  
  end
  
  def self.find_by_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
    SQL
    results.each { |result| Reply.new(result) unless result.nil?}
  end
  
  def author
    User.find_by_id(@user_id)
  end
  
  def question
    Question.find_by_id(@question_id)
  end
  
  def parent_reply
    Reply.find_by_id(@parent_id)
  end
  
  def child_reply
    results = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_id = ?
    SQL
    results.each { |result| Reply.new(result) unless result.nil?}
  end
  

  
end
