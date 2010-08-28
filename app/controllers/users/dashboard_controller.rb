class Users::DashboardController < Users::MainController
  
  before_filter :criar_folder
  
  def index
  end
  
  private
  
  def criar_folder
    unless current_user.folder_id
      folder_id = Hominid::Loader.instance.create_folder(current_user.folder_name)
      current_user.folder_id = folder_id
      current_user.save!
    end
  end
  
end