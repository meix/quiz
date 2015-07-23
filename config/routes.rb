Rails.application.routes.draw do
  get 'admin', to: 'admin/questions#index'

  mount API => '/'  # Grape APIs

  namespace :admin do
    resources :questions do
      collection do
        get :question_manage_panel
        post :import
      end
    end
    resources :question_options do
      collection do
        post 'add_question_option'
      end
    end
    resources :train_logs
    resources :train_scores
  end

end
