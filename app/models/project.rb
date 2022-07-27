class Project < ActiveRecord::Base

    validates_uniqueness_of :title
    has_many :artifacts, dependent: :destroy
    has_many :user_projects
    has_many :users, through: :user_projects
    validate :free_plan_can_only_have_one_project
    
    def free_plan_can_only_have_one_project
    
    end
  end