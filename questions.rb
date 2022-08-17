require "singleton"
require "sqlite3"


class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    attr_accessor :id, :fname, :lname

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        return nil unless user.length > 0

        User.new(user.first)
    end

    def self.find_by_name(fname, lname)
        user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT
                *
            FROM
                users
            WHERE
                fname = ? AND lname = ?
        SQL
        return nil unless user.length > 0

        User.new(user.first)
    end

    def authored_questions
        raise "#{self} not in database" unless self.id

        Question.find_by_author_id(self.id)
    end

    def authored_replies
        raise "#{self} not in database" unless self.id

        Reply.find_by_user_id(self.id)        
    end

    def followed_questions
        QuestionFollow.followers_for_question_id(self.id)
    end

end

class Question
    attr_accessor :id, :title, :body, :author_id

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def self.find_by_author_id(author_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                author_id = ?
        SQL
        return nil unless question.length > 0

        Question.new(question)
    end

    def author
        author = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                replies
            WHERE
                author_id = ?
        SQL
        return nil unless author.length > 0

        Question.new(author)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

    def followers
        QuestionFollow.followers_for_question_id(self.id)
    end
end

class QuestionFollow
    attr_accessor :id, :follower_id, :question_id

    def initialize(options)
        @id = options['id']
        @follower_id = options['follower_id']
        @question_id = options['question_id']
    end

    def self.followers_for_question_id(question_id)
        followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                question_follows
            JOIN
                questions ON questions.id = question_follows.question_id
            WHERE
                question_id = ?
        SQL
        return nil unless followers.length > 0

        User.new(followers)
    end

    def self.followed_questions_for_user_id(user_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT
                *
            FROM
                question_follows
            JOIN
                users ON users.id = question_follows.follower_id
            WHERE
                user_id = ?
        SQL
        return nil unless questions.length > 0

        Question.new(questions)
    end

    

end

class Reply
    attr_accessor :id, :question_id, :body, :author_id, :parent_reply_id

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @body = options['body']
        @author_id = options['author_id']
        @parent_reply_id = options['parent_reply_id']
    end

    def self.find_by_user_id(user_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                replies
            WHERE
                author_id = ?
        SQL
        return nil unless reply.length > 0

        Reply.new(reply)
    end

    def self.find_by_question_id(question_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        return nil unless reply.length > 0

        Reply.new(reply)
    end

    def author
        author = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                replies
            WHERE
                author_id = ?
        SQL
        return nil unless author.length > 0

        Reply.new(author)
    end

    def question
        question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        return nil unless question.length > 0

        Reply.new(question)
    end

    def parent_reply
        reply = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
        return nil unless reply.length > 0

        Reply.new(reply)
    end

    def child_replies
        replies = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
        return nil unless replies.length > 0

        Reply.new(replies)
    end
end

class QuestionLike
    attr_accessor :id, :question_id, :author_id

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @author_id = options['author_id']
    end

end
