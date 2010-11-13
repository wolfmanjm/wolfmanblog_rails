class StaticsController < ApplicationController
  USERS = { "morris" => "qaz1xsw" }
  before_filter :authenticate

  # GET /statics
  # GET /statics.xml
  def index
    @statics = Static.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @statics }
    end
  end

  # GET /statics/1
  # GET /statics/1.xml
  def show
    @static = Static[params[:id]]

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @static }
    end
  end

  # GET /statics/new
  # GET /statics/new.xml
  def new
    @static = Static.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @static }
    end
  end

  # GET /statics/1/edit
  def edit
    @static = Static[params[:id]]
  end

  # POST /statics
  # POST /statics.xml
  def create
    @static = Static.new(params[:static])

    respond_to do |format|
      if @static.save
        format.html { redirect_to(@static, :notice => 'Static was successfully created.') }
        format.xml  { render :xml => @static, :status => :created, :location => @static }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @static.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statics/1
  # PUT /statics/1.xml
  def update
    @static = Static[params[:id]]

    respond_to do |format|
      if @static.update(params[:static])
        format.html { redirect_to(@static, :notice => 'Static was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @static.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statics/1
  # DELETE /statics/1.xml
  def destroy
    @static = Static[params[:id]]
    @static.destroy

    respond_to do |format|
      format.html { redirect_to(statics_url) }
      format.xml  { head :ok }
    end
  end

  private

  def authenticate
    result = authenticate_or_request_with_http_digest do |username|
      if session[:logout_requested]
        session[:logout_requested] = nil   # reset flag
        false
      else
        USERS[username]
      end
    end

    if result == true
      session[:logged_in]= true
    else
      session[:logged_in]= nil
    end

  end

end
