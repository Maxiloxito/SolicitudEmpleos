class SessionsController < ApplicationController
  def new
    render :login
  end

  def create
    user = User.find_by(email: params[:email].downcase)
  
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
  
      if user.employee?
        redirect_to dashboard_path
      elsif user.employer?
        redirect_to dashboard_path
      else
        redirect_to root_path, notice: 'Inicio de sesión exitoso.'
      end
  
    else
      flash[:danger] = 'Email o contraseña inválidos'
      redirect_to login_path
    end
  end
  
  

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Has cerrado sesión exitosamente."
  end
  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: 'Has cerrado sesión con éxito.'
  end
end
