Rails.application.routes.draw do

  resources :user_projects
  resources :artifacts
    resources :projects do
      get 'users', on: :member 
      put 'add_user', on: :member 
    end
  resources :members
  get 'home/index'

   root :to => "home#index"

    
  # *MUST* come *BEFORE* devise's definitions (below)
  as :user do   
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  devise_for :users, :controllers => { 
    :registrations => "registrations",
    :confirmations => "confirmations",
   
  }
  
  
end
