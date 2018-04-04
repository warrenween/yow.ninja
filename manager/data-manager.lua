module(..., package.seeall)

local json = require( "json" )
local yoyow_bts_ai = require("network.yoyow-bts-ai")

function queryAccountInfo(username, uiInfoTableView)
  yoyow_bts_ai.queryAccountInfo(
    username,
    function(event)
      if (string.find(event.response, "The page you were looking for doesn't exist (404)")) then
        print("The page you were looking for doesn't exist (404)")
        local  rowHeight = math.ceil(display.contentHeight * 0.5 * 0.1)
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "404 Service Temporarily Unavailable. Try Later."}})
      else
        local accountInfo = json.decode(event.response)

        uiInfoTableView:insertRow({
            isCategory = true,
            params = {
              text = username .. 
              " - Account Info"
            }
          })

        local  rowHeight = math.ceil(display.contentHeight * 0.5 * 0.1)
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "uid: " ..  accountInfo["account"]["uid"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "name: " ..  accountInfo["account"]["name"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "balance: " ..  accountInfo["statistics"]["core_balance"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "average coins: " ..  accountInfo["statistics"]["average_coins"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "create time: " ..  accountInfo["account"]["create_time"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "last update time: " ..  accountInfo["account"]["last_update_time"]}})
      end
    end)
end

function queryWitnessInfo(username, uiInfoTableView)
  yoyow_bts_ai.queryAccountInfo(
    username,
    function(event)
      if (string.find(event.response, "The page you were looking for doesn't exist (404)")) then
        print("The page you were looking for doesn't exist (404)")
        local  rowHeight = math.ceil(display.contentHeight * 0.5 * 0.1)
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "404 Service Temporarily Unavailable. Try Later."}})
      else
        local accountInfo = json.decode(event.response)

        uiInfoTableView:insertRow({
            isCategory = true,
            params = {
              text = username .. 
              " - Witness Info"
            }
          })

        local  rowHeight = math.ceil(display.contentHeight * 0.5 * 0.1)
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "uid: " ..  accountInfo["witness"]["account"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "name: " ..  accountInfo["witness"]["name"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "url: " ..  accountInfo["witness"]["url"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "pledge: " ..  accountInfo["witness"]["pledge"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "total produced: " ..  accountInfo["witness"]["total_produced"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "total missed: " ..  accountInfo["witness"]["total_missed"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "last confirmed block num: " ..  accountInfo["witness"]["last_confirmed_block_num"]}})
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "last aslot: " ..  accountInfo["witness"]["last_aslot"]}})

      end
    end)
end

function queryWitnessVotes(username, uiInfoTableView)
  yoyow_bts_ai.queryAccountInfo(
    username,
    function(event)
      if (string.find(event.response, "The page you were looking for doesn't exist (404)")) then
        print("The page you were looking for doesn't exist (404)")
        local  rowHeight = math.ceil(display.contentHeight * 0.5 * 0.1)
        uiInfoTableView:insertRow({
            rowHeight = rowHeight, 
            params = {text = "404 Service Temporarily Unavailable. Try Later."}})
      else
        local accountInfo = json.decode(event.response)

        uiInfoTableView:insertRow({
            isCategory = true,
            params = {
              text = username .. 
              " - Witness Votes"
            }
          })

        local  rowHeight = math.ceil(display.contentHeight * 0.5 * 0.1)

        for i = 1, #accountInfo["witness_votes"] do
          uiInfoTableView:insertRow({
              rowHeight = rowHeight, 
              params = {text = "uid: " ..  accountInfo["witness_votes"][i]}})
        end
      end
    end)
end

