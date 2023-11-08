class DashboardController < ApplicationController

    
    def index
        if current_user.employee?
            @job_offers = JobOffer.available
            render 'employee_dashboard'
        elsif current_user.employer?
            @replacement_requests = current_user.replacement_requests
            @job_offers = current_user.job_offers 
            render 'employer_dashboard'
        end
    end

    def employer_dashboard
        @replacement_requests = current_user.replacement_requests || []
        @job_offers = current_user.job_offers || [] 
    end
end
