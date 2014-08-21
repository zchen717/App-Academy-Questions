require_relative 'questionsdb'
require_relative 'user'
require_relative 'reply'
require_relative 'question_follower'
require_relative 'question_like'

class Question
  attr_accessor :id, :title, :body, :author_id
  def initialize(options = {})
    @id, @title, @body, @author_id =
    options.values_at('id', 'title', 'body', 'author_id')
  end
  
  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        questions.id = ?
    SQL
    results.empty? ? nil : Question.new(results.first) ##what if the id not exit
  end
  
  def self.find_by_author_id(author_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      author_id = ?
    SQL
    results.each { |result| Question.new(result) unless result.nil?}
  end
  
  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end
  
  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end
  
  def author
    User.find_by_id(@author_id)
  end
  
  def replies
    Reply.find_by_question_id(@id)
  end
  
  def followers
    QuestionFollower.followers_for_question_id(@id)
  end
  
  def likers
    QuestionLike.likers_for_question_id(@id)
  end
  
  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  
end