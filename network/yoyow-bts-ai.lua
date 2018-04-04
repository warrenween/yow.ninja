module(..., package.seeall)

local json = require( "json" )

function queryAccountInfo(username, callback)
  
  local body = ""
  local params = {}
  params.body = body

  network.request( "https://yoyow.bts.ai/api/v1/get_full_account?uid=" .. username, 
    "GET", 
    function(event)
      if ( event.isError ) then
        print( "Network error: ", event.response )
      else
        print ( "RESPONSE: " .. event.response )
      end
      callback(event)
    end, 
    params )
end
