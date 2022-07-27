Rails.application.routes.draw do
<<<<<<< HEAD

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
  
  
=======
  root 'home#index'
>>>>>>> fd4ff0debe0a4e6620a45c7847b496c095b699c5
end
