class DomainsController < ApplicationController
    before_action :logged_in_user
    def index
        @domains = Domain.paginate(page: params[:page], per_page: 15)
        @count = Domain.count
    end
    
    def create
        @domain = Domain.new(domain_params)
        if @domain.save
            #
            flash[:success] = "添加成功"
            redirect_to '/domains'
        else
            render 'index'
        end
        
    end

    def show
        @domain = Domain.find(params[:id])
        @subdomains = @domain.sub_domains.paginate(page: params[:page])
        @count = SubDomain.count
    end
    
    def edit
      @domain = Domain.find(params[:id])
    end
    
    def update
      @domain = Domain.find(params[:id])
      if @domain.update_attributes(domain_params)
        flash[:success] = "修改成功"
        redirect_to @domain
      else
        render 'edit'
      end
      
    end
    
    def destroy
      Domain.find(params[:id]).destroy
      flash[:success] = "删除成功"
      redirect_to '/domains'
    end
    

    private
        def domain_params
            params.require(:domain).permit(:dname, :dip, :dtitle)
        end
end
