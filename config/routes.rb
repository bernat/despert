Intranet::Application.routes.draw do
  devise_for :users, :controllers => {:sessions => "user_sessions"}

  match "overview/list", :to => "overview#list"
  match "dashboard", :to => "overview#dashboard", :as => :dashboard

  resources :employees

  # Despert
  # ================================================================
  resources :groups
  resources :comments, :only => :destroy

  resources :project_types

  resources :projects, :only => :index
  resources :projects, :path => "", :except => :index do
    collection do
      get :list
    end

    resources :attachments

    resources :messages do
      collection do
        get :list
      end
    end

    resources :milestones do
      member do
        get :toggle
      end
    end

    resources :task_lists do
      resources :tasks, :only => :create

      collection do
        post :reorder_task
      end

      member do
        post :toggle_archive
        get :completed_tasks
      end
    end

    resources :tasks do
      member do
        get :toggle
        get :archive_toggle
        get :list_events
      end
    end
  end

  resources :tasks, :only => :none do
    resources :comments, :only => :create
  end

  resources :milestones, :only => :none do
    resources :comments, :only => :create

    collection do
      get :overview
    end
  end

  resources :messages, :only => :none do
    resources :comments, :only => :create
  end


  root :to => "overview#index"
end

