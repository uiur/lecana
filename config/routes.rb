Opilio::Application.routes.draw do
  ActiveAdmin.routes(self)

  match "/logout" => "sessions#destroy", :as => :logout
  match "/auth/:provider/callback" => "sessions#create"
  
  root :to => "home#index" 
  get '/about' => 'statics#about', :as => :about

  get '/users' => "users#index", :as => :users
  get '/set_name' => 'home#set_name'
  put '/update_name'=> 'home#update_name'

  scope '/users/:name', :name => /[^\/]*/, :as => :user do
    get '/' => 'users#show'
    get 'timetable' => 'users#timetable', :as => :timetable
    post 'copy_timetable' => 'users#copy_timetable', :as => :copy_timetable
    resources :reviews, :only => [:index]
    resources :posts, :only => [:index]
  end

  get '/settings/faculty_select/:id' => 'settings#faculty_select', :as => :faculty_select

  resource :settings, :only => [:new, :create, :edit, :update]

  resources :subjects, :only => [:index, :new, :create] do
    resources :posts, :only => [:create, :destroy]
    resources :reviews, :only => [:create, :destroy]
    resources :notes, :only => [:new, :create, :index, :show]
    resources :uploads, :only => [:create, :destroy]
    member do
      post :register
      post :remove
    end
    post "tags" => 'subjects#create_tag', :as => :create_tag
    delete "tags" => 'subjects#remove_tag', :as => :remove_tag
  end

  get '/subjects/:id(/:year)' => 'subjects#show', :as => :subject

  get 'teachers/autocomplete_teacher_name' => 'teacher#autocomplete_teacher_name'

  resources :posts, :only => [:show, :create, :destroy] do
    resources :favs, :only => [:create, :destroy]
  end

  resources :reviews, :only => [:show] do
    resources :favs, :only => [:create, :destroy]
  end

  scope "/note/:note_id", :as => :note do
    resources :favs, :only => [:create, :destroy]
  end
  
  match '*a' => 'statics#routing_error' 
end
