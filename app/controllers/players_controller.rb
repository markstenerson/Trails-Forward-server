class PlayersController < ApplicationController
  before_filter :authenticate_user!

  # GET /users/:id/players
  def index
    @user = User.find(params[:user_id])
    @players = @user.players

    authorize! :index_user_players, @user

    if can? :access_private_data, @user
      template_to_use = :player_private
    else
      template_to_use = :player_public
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render_for_api template_to_use, :xml  => @players  }
      format.json  { render_for_api template_to_use, :json  => @players  }
    end
  end

  # GET /users/:user_id/players/:id
  def show
    @user = User.find params[:user_id]
    @player = @user.players.where(:id => params[:id]).first

    authorize! :show_player, @player

    if can? :access_private_data, @player
      template_to_use = :player_private_with_megatiles
    else
      template_to_use = :player_public_with_megatiles
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render_for_api template_to_use, :xml  => @player  }
      format.json  { render_for_api template_to_use, :json  => @player  }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
    authorize! :update_player, @player
  end

  def bids_placed
    @player = Player.find(params[:player_id])
    authorize! :see_bids, @player

    @bids = @player.bids_placed
    if params.has_key? :active
      @bids = @bids.where(:status => Bid.verbiage[:active])
    end

    respond_to do |format|
      format.json { render_for_api :bid_private, :json => @bids, :root => :bids }
      format.xml  { render_for_api :bid_private, :xml  => @bids, :root => :bids }
    end
  end


  def update
    @player = Player.find(params[:id])
    authorize! :update_player, @player

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to(@player, :notice => 'Player was successfully updated.') }
        format.xml  { render_for_api :player_private, :xml  => @player }
        format.json { render_for_api :player_private, :json => @player }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml  => @player.errors, :status => :unprocessable_entity }
        format.json { render :json => @player.errors, :status => :unprocessable_entity }
      end
    end
  end
end
