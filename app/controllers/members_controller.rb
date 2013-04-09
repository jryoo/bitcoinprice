class MembersController < ApplicationController
  before_filter :set_carriers

  def index
    #@members = Member.all

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @members }
    #end
  end

  def show
    #@member = Member.find(params[:id])

    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.json { render json: @member }
    #end
  end

  def new
    @member = Member.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @member }
    end
  end

  def edit
    #@member = Member.find(params[:id])
  end

  def create
    @member = Member.new(params[:member])
    
    respond_to do |format|
      if @member.save
        Member.send_subscribed(@member.number, @member.carrier)
        format.html { redirect_to root_path, notice: 'Member was successfully created.' }
        format.json { render json: @member, status: :created, location: @member }
      else
        flash[:error] = 'Could not subscribe this number'
        format.html { render action: "new", notice: 'Member was not successfully created.' }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    #@member = Member.find(params[:id])

    #respond_to do |format|
    #  if @member.update_attributes(params[:member])
    #    format.html { redirect_to @member, notice: 'member was successfully updated.' }
    #    format.json { head :no_content }
    #  else
    #    format.html { render action: "edit" }
    #    format.json { render json: @member.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  def unsubscribe
    @member = Member.new
    member = Member.find_by_number(params[:member][:number])

    if member
      Member.send_unsubscribed(member.number, member.carrier)
    end

    respond_to do |format|
      if member and member.destroy
        format.html { redirect_to new_member_path, notice: 'Member was successfully unsubscribed.'}
        format.json { head :no_content }
      else
        flash[:error] = 'This number is not in the database'
        format.html { redirect_to root_path, error: 'Member was not successfully unsubscribed.' }
        format.json { render json: member.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end
end