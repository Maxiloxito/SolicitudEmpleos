class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :require_correct_user_or_admin, only: [:edit, :update]

  def edit
  end

  def new
    @user = User.new
    render :register
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id 
      redirect_to root_path, notice: 'Usuario registrado con éxito.'
    else
      render :register
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Tu perfil ha sido actualizado.'
    else
      render :edit
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "An error occurred: #{e.message}"
    render :edit
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    flash[:error] = "There was a problem with your file upload."
    render :edit
  end
  
  
  def show
    @user = User.find(params[:id])
  end
  
  


  private
  def set_user
    @user = User.find(params[:id])
    @user.languages = @user.languages.split(',').map(&:strip) if @user.languages.is_a?(String)
  end

  def require_correct_user_or_admin
    unless current_user == @user || current_user.admin?
      redirect_to root_path, alert: 'No tienes permiso para editar este perfil.'
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :location, :contact, :engineering_type, :password, :password_confirmation, :experience, {languages: []}, :resume, :role, :profile_picture)
  end

end
