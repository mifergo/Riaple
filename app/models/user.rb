require 'digest/sha2'

class User < ActiveRecord::Base
  belongs_to :location
  has_many :tasks

  # A Pig and a Chicken are walking down the road. The Chicken says, "Hey Pig, I was thinking we should open a restaurant!".
  # Pig replies, "Hm, maybe, what would we call it?".
  # The Chicken responds, "How about 'ham-n-eggs'?".
  # The Pig thinks for a moment and says, "No thanks. I'd be comitted, but you'd only be involved!"

  CHICKENS = ["Observer", "Admin", "Owner"]
  PIGS = ["Developer", "Master"]
  ROLES = CHICKENS + PIGS

  scope :admin, where(:rol => 'Admin')
  scope :assignable, where("rol in (?)", PIGS)

  validates :email, :presence => true, :uniqueness => true
  validates_presence_of :name, :surname
  validates :password, :confirmation => true
  attr_accessor :password_confirmation
  attr_reader   :password
  after_destroy :ensure_an_admin_remains

  validate  :password_must_be_present

  def User.authenticate(login, password)
    if user = find_by_login(login)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end

  def User.encrypt_password(password, salt)
    Digest::SHA2.hexdigest(password + "riaple" + salt)
  end

  # 'password' is a virtual attribute
  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end
  end

  private

    def password_must_be_present
      errors.add(:password, "Missing password") unless hashed_password.present?
    end

    def generate_salt
      self.salt = self.object_id.to_s + rand.to_s
    end

    def ensure_an_admin_remains
      if User.admin.count.zero?
        raise "Can't delete last master user"
      end
    end
end
