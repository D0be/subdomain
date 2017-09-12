class SubDomainsController < ApplicationController
  before_action :logged_in_user
  def index
  end

  def create
    @domain = Domain.find(params[:domain_id])
    @subdomain = @domain.sub_domains.build(subdomain_params)
    if @subdomain.save
      flash[:success] = "添加子域名成功"
      redirect_to @domain
    else
      @subdomains = @domain.sub_domains.paginate(page: params[:page])
      render 'domains/show'
    end
    
  end

  def new
  end

  def import
    @domain = Domain.find(params[:domain_id])
    uploader = SubdomainUploader.new
    if uploader.store!(params[:file])
       uploader.read.split("\n").each do |line|
         tmp = line.split
         @domain.sub_domains.create!(sname: tmp[0], sip: tmp[1], domain_id: params[:domain_id])
        end
        
       redirect_to @domain
    else
       flash[:danger] = "上传失败"
       redirect_to '/domains'
      end
      
  end
  
  def export
    @domain = Domain.find(params[:id])
    subdomains = @domain.sub_domains.all
    content = ''
    subdomains.each do |subdomain|
      content += subdomain.sname + ' ' * 4 + subdomain.sip + "\n"
    end
    send_data content, filename: @domain.dname + '.txt', type: 'text/plain', :disposition => 'attachment'
  end


  def edit
    @subdomain = SubDomain.find(params[:id])
  end
  
  def update
    @subdomain = SubDomain.find(params[:id])
    domain = @subdomain.domain
    if @subdomain.update_attributes(subdomain_params)
      flash[:success] = "修改成功"
      redirect_to domain
    else
      render 'edit'
    end
  end
  
  def destroy
      domain = SubDomain.find(params[:id]).domain    
      SubDomain.find(params[:id]).destroy
      flash[:success] = "删除成功"
      redirect_to domain
  end

  private
    def subdomain_params
      params.require(:sub_domain).permit(:sname, :sip)
    end
    

end
