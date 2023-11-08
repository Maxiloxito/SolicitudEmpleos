class JobOffersController < ApplicationController
  before_action :authenticate_employer 
  before_action :find_job_offer, only: [:show, :edit, :update, :applicants]

  def index
    @job_offers = JobOffer.all
  end

  def new
    @job_offer = JobOffer.new
    @job_offer.languages = [] 
  end
  

  def create
    @job_offer = current_user.job_offers.build(job_offer_params)

    if @job_offer.save
      redirect_to employer_dashboard_path, notice: 'La oferta de trabajo ha sido cargada exitosamente.'
    else
      render :new
    end
  end

  def show
    @job_offer = JobOffer.find(params[:id])
  end
  
  
  def job_offer_params
    params.require(:job_offer).permit(:title, :position, :description, :location, :salary, :availability, languages: [])
  end
  

  def edit
    @job_offer = JobOffer.find(params[:id])
  end
  
  def update
    @job_offer = JobOffer.find(params[:id])
  
    if @job_offer.update(job_offer_params)
      redirect_to @job_offer, notice: 'Oferta de trabajo actualizada con éxito.'
    else
      render :edit
    end
  end
  
  def applicants
    @job_offer = find_job_offer
    @applicants = @job_offer.applicants
  
    case params[:sort_by]
    when 'languages'
      @sorted_applicants = sort_applicants_by_language(@applicants, @job_offer.languages)
    when 'experience'
      @sorted_applicants = sort_applicants_by_experience(@applicants)
    when 'location'
      @sorted_applicants = sort_applicants_by_location(@applicants, @job_offer.location)
    when 'score'
      @sorted_applicants = sort_applicants_by_score(@applicants, @job_offer)
    when 'position'
      @sorted_applicants = sort_applicants_by_position(@applicants, @job_offer.position)
    else
      @sorted_applicants = @applicants
    end

  end
  
  
  
  
  private
  
  

  def sort_applicants_by_language(applicants, job_offer_languages)
    
    applicants.sort_by do |applicant|
      preferred_languages_spoken = (applicant.languages & job_offer_languages).size
      total_languages_spoken = applicant.languages.size
      [-preferred_languages_spoken, -total_languages_spoken]
    end
  end
  
  
  
  
  
  
  def sort_applicants_by_experience(applicants)
    applicants.sort_by { |applicant| -applicant.experience.to_i }
  end

  def sort_applicants_by_location(applicants, job_offer_location)
    applicants.sort_by { |applicant| applicant.location == job_offer_location ? 0 : 1 }
  end
  
  def sort_applicants_by_position(applicants, job_offer_position)
    applicants.sort_by { |applicant| applicant.engineering_type == job_offer_position ? 0 : 1 }
  end

  def find_job_offer
    @job_offer ||= JobOffer.find(params[:id])
  end
  
  def applicants_for_offer(job_offer)
    job_offer.users
  end


  def calculate_score(applicant, job_offer)
    score = 0
    score += applicant.experience * experience_weight
    score += 50 * language_weight if applicant.languages.include?(job_offer.language)
    score += 50 * location_weight if applicant.location == job_offer.location
    score += 30 * position_weight if applicant.engineering_type == job_offer.position
    score
  end
  
  
  
  

  def experience_weight
    5 
  end
    
  def language_weight
    5 
  end

  def position_weight
    5 
  end
  
  def location_weight
    5 
  end

    

  def sort_applicants_by_score(applicants, job_offer)
    applicants.sort_by do |applicant|
      applicant.score = calculate_score(applicant, job_offer)
      puts "Applicant #{applicant.email} Score: #{applicant.score}"
      -applicant.score
    end
  end


  def authenticate_employer
    redirect_to some_path unless current_user && current_user.employer?
  end
end
