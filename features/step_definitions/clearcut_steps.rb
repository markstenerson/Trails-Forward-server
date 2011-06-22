Given /^my megatile is completely zoned for logging$/ do
  @my_megatile.resource_tiles.each do |rt|
    rt.zoned_use = ResourceTile::Verbiage[:zoned_uses][:logging]
    rt.save!
  end
end


When /^I clearcut a resource tile on the megatile that I own$/ do
  @my_resource_tile = @my_megatile.resource_tiles.first
  @old_balance = @player.balance
  @response = post clearcut_world_resource_tile_path(@world, @my_resource_tile), 
    :format => :json, 
    :auth_token => @user.authentication_token
  decoded = ActiveSupport::JSON.decode(@response.body)
  decoded.has_key?("resource_tile").should be true
  decoded["resource_tile"].has_key?("id").should be true
end

Then /^that resource tile should have no trees$/ do
  @my_resource_tile.reload
  @my_resource_tile.tree_density.should == 0.0
  @my_resource_tile.tree_size.should == 0.0
end

Then /^my bank balance should increase$/ do
  #is this suppose to be only > or can we have no profit when clearcutting
  @player.balance.should >= @old_balance
end