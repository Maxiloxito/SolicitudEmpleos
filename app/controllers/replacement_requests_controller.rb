class ReplacementRequestsController < ApplicationController
  before_action :set_job_offer, only: [:create]

  def create
    @replacement_request = current_user.replacement_requests.build(replacement_request_params)

    if @replacement_request.save
      flash[:notice] = "Postulación realizada con éxito."
      redirect_to employee_dashboard_path
    else
      flash[:alert] = "No se pudo realizar la postulación."
      render 'employee_dashboard' 
    end 
  end 

  private
  
  def set_job_offer
    @job_offer = JobOffer.find(params[:replacement_request][:job_offer_id])
  end

  def replacement_request_params
    params.require(:replacement_request).permit(:job_offer_id)
  end
end  
