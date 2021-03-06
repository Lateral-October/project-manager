class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
         
  belongs_to :tenant
  belongs_to :client
  has_and_belongs_to_many :projects
  
  after_create :send_welcome_email
  
  def is_admin?
    if self.admin || self.superuser
      true
    else
      false
    end
  end
  
  def is_superuser?
    self.superuser
  end
  
  def full_name
    [first_name, last_name].join(' ')
  end
  
  def is_user?
    if !is_admin?
      true
    else
      false
    end
  end
  
  private
    def send_welcome_email
      UserMailer.delay(:queue => "email").welcome_email(self)
    end
  
end
