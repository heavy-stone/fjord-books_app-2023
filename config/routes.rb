Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books do
    resources :comments, only: %i(create destroy), controller: 'books/comments'
  end
  resources :users, only: %i(index show)
  resources :reports do
    resources :comments, only: %i(create destroy), controller: 'reports/comments'
  end
end
