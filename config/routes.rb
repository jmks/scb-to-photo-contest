PhotoContest::Application.routes.draw do
  
  devise_for :judges, controllers: { sessions: 'judges/sessions' }, skip: [:registrations]

  devise_for :contestants, controllers: { registrations: 'registrations' }

  root to: 'root#index'
  get '/prizes',   to: 'root#prizes',  as: 'prizes'
  get '/judges',   to: 'root#judges',  as: 'judges'
  get '/rules',    to: 'root#rules',   as: 'rules'
  get '/about',    to: 'root#about',   as: 'about'
  post '/contact', to: 'root#contact', as: 'contact'
  get '/terms',    to: 'root#terms',   as: 'terms'
  get '/contest',  to: 'root#contest', as: 'contest'
  get '/photo_criteria', to: 'root#judging_criteria', as: 'photo_criteria'

  get '/contestant', to: 'contestants#index', as: 'contestant_index'

  get '/photos',            to: 'photos#index',      as: 'photos'
  get '/photos/flora',      to: 'photos#flora',      as: 'flora'
  get '/photos/fauna',      to: 'photos#fauna',      as: 'fauna'
  get '/photos/landscapes', to: 'photos#landscapes', as: 'landscapes'
  
  post '/photos/:id/comment',   to: 'photos#comment',        as: 'new_comment'
  get '/photos/:id/comments(/:page)', to: 'photos#comments', as: 'photo_comments'
  post '/photos/:id/vote',      to: 'photos#vote',           as: 'vote_photo'
  post '/photo/report_comment', to: 'photos#report_comment', as: 'report_comment'

  resources :photos do
    get 'page/:page', action: 'index', on: :collection, as: 'page'
  end

  #dep
  get  '/photo_entry',        to: 'photo_entry#workflow', as: 'workflow_photo_entry'

  # photo entry
  get  '/photo_entry/new',    to: 'photo_entry#new',      as: 'new_photo_entry'
  post '/photo_entry',        to: 'photo_entry#create',   as: 'photo_entry'
  get  '/photo_entry/order',  to: 'photo_entry#order',    as: 'order'
  get  '/photo_entry/verify', to: 'photo_entry#verify',   as: 'verify'
  post '/photo_entry/verify_orders', to: 'photo_entry#verify_orders', as: 'verify_orders'
  get  '/photo_entry/share',  to: 'photo_entry#share',    as: 'share_photos'

  # tags
  get '/tags', to: 'tag#index', as: 'tags'

  # admin
  get  '/admin',                   to: 'admin#index',         as: 'admin_root'
  post '/admin/confirm_photo/:id', to: 'admin#confirm_photo', as: 'admin_confirm_photo'
  post '/admin',                   to: 'admin#add_judge',     as: 'admin_add_judge'

  # judges
  get  '/judges/index',     to: 'judges#index',           as: 'judge_root'
  post '/judges/shortlist', to: 'judges#shortlist_photo', as: 'judge_shortlist'
  post '/judges/shortlist_remove', to: 'judges#remove_from_shortlist', as: 'judge_shortlist_remove'

  # judge scoring
  get  '/judges/photo_score/:id', to: 'judge_score#score_photo',           as: 'photo_score'
  post '/judges/photo_score/:id', to: 'judge_score#save_photo_score',      as: 'save_photo_score'
  post '/judges/photo_score',     to: 'judge_score#finalize_photo_scores', as: 'finalize_photo_scores'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
