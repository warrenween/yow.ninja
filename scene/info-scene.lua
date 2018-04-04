local composer = require( "composer" )
local widget = require( "widget" )
local json = require( "json" )
local data_manager = require("manager.data-manager")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local uiUsername = nil
local uiInfoText = nil
local uiInfoTableView = nil
local uiInfoTableViewCurrentIndex = 1
local uiPickerWheel = nil
local uiPickerWheelCancelButton = nil
local uiPickerWheelConfirmButton = nil
local uiCategoryButton = nil
local uiQueryButton = nil
local arrayUsernames = {}

local uiPickerWheelGroup = nil

local function parseUsernames(usernames)
  -- clear array first
  arrayUsernames = {}
  for i in string.gmatch(usernames, "%S+") do
    print(i)
    -- put it into array
    table.insert(arrayUsernames, i)
  end
end

local function getValueTableFromString(stringNumber)

  local tempRow

  if stringNumber == "Account Info" then
    tempRow = 1
  elseif stringNumber == "Witness Info" then
    tempRow = 2
  elseif stringNumber == "Witness Votes" then
    tempRow = 3
  else
    tempRow = 1
  end

  local valueTable = {
    column = 1,
    row = tempRow
  }

  print(valueTable.column .. valueTable.row)
  --end

  return valueTable

end

local function onUsername(event)
  if ( "began" == event.phase ) then
    -- This is the "keyboard appearing" event.
    -- In some cases you may want to adjust the interface while the keyboard is open.

  elseif ( "submitted" == event.phase ) or (event.phase == "ended") then
    native.setKeyboardFocus( nil )
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  uiUsername = native.newTextField( 
    display.contentCenterX, 
    display.contentCenterY * 0.25, 
    display.contentWidth * 0.98, 
    display.contentHeight * 0.1 
  )
  uiUsername.font = native.newFont( 
    native.systemFont, 
    display.contentHeight * 0.02
  )
  uiUsername.isEditable = true
  uiUsername.placeholder  = "Input username here. Use 'SPACE' to separate multiple users."
  uiUsername:addEventListener("userInput", onUsername)

  -- Create the widget
  uiInfoTableView = widget.newTableView(
    {
      x = display.contentCenterX,
      y = display.contentCenterY * 0.9,
      height = display.contentHeight * 0.5,
      width = display.contentWidth * 0.98,
      backgroundColor = { 0.8, 0.8, 0.8 },
      onRowRender = 
      function(event)
        -- Get reference to the row group
        local row = event.row

        -- Cache the row "contentWidth" and "contentHeight" 
        -- because the row bounds can change as children objects are added
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth

        local rowTitle
        rowTitle = display.newText( row, row.params.text, 0, 0, nil, 10 )
        rowTitle:setFillColor( 0 )

        rowTitle.anchorX = 0
        rowTitle.x = 10
        rowTitle.y = rowHeight * 0.5
      end,
      onRowTouch = onRowTouch,
      listener = scrollListener
    }
  )

  uiCategoryButton = widget.newButton(
    {
      x = display.contentCenterX,
      y = display.contentCenterY * 1.5,
      width = display.contentWidth * 0.98,
      height = display.contentHeight * 0.05,
      id = "categoryButton",
      label = "Account Info",
      shape = "rect",
      labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } }, 
      fillColor = { default={ 0.5, 0.5, 0.5, 0.7 }, over={ 0.5, 0.5, 0.5, 1 } },
      onRelease = function(event)
        if ( "ended" == event.phase ) then
          local valueTable = getValueTableFromString(uiCategoryButton:getLabel())
          uiPickerWheel:selectValue(valueTable.column, valueTable.row)
          uiPickerWheelGroup.isVisible = true
        end
      end

    }
  )

  uiQueryButton = widget.newButton(
    {
      x = display.contentCenterX,
      y = display.contentCenterY * 1.8,
      --width = display.contentWidth * 0.98,
      height = display.contentHeight * 0.08,
      id = "queryButton",
      label = "QUERY / REFRESH",
      shape = "rect",
      labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
      fillColor = { default={ 0.4, 0.8, 0.5, 0.7 }, over={ 0.4, 0.8, 0.5, 1 } },
      onRelease = function(event)
        if ( "ended" == event.phase ) then
          print( "Button was pressed and released" )
          -- clear all rows first
          uiInfoTableView:deleteAllRows()
          -- parse usernames
          parseUsernames(uiUsername.text)
          ---[[ check picker wheel values
          local category = uiCategoryButton:getLabel()
          for i = 1, #arrayUsernames do
            if category == "Account Info" then 
              data_manager.queryAccountInfo(arrayUsernames[i], uiInfoTableView)
            elseif category == "Witness Info" then
              data_manager.queryWitnessInfo(arrayUsernames[i], uiInfoTableView)
            elseif category == "Witness Votes" then
              data_manager.queryWitnessVotes(arrayUsernames[i], uiInfoTableView)
            else
              data_manager.queryAccountInfo(arrayUsernames[i], uiInfoTableView)
            end
          end
          --]]
        end
      end

    }
  )

  uiPickerWheel = widget.newPickerWheel(
    {
      x = display.contentCenterX,
      y = display.contentCenterY * 1.8,
      columns = { 
        { 
          startIndex = 1,
          labels = {  
            "Account Info",
            "Witness Info",
            "Witness Votes",
          }
        }
      },
      style = "resizable",
      width = display.contentWidth,
      rowHeight = math.floor(display.contentHeight * 0.04),
      fontSize = display.contentHeight * 0.025,
      fontColorSelected = { 0, 0, 1 },
    })

  uiPickerWheelCancelButton = widget.newButton
  {
    label = "CANCEL",
    shape = "rect",
    x = display.contentCenterX * 0.45,
    y = display.contentCenterY * 1.55,
    width = display.contentWidth * 0.4,
    height = display.contentHeight * 0.05,
    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } }, 
    fillColor = { default={ 1, 0.2, 0.5, 0.7 }, over={ 1, 0.2, 0.5, 1 } },
    emboss = true,
    onRelease = function(event)
      print('cancel button clicked')
      -- just close the picker wheel group, nothing more
      uiPickerWheelGroup.isVisible = false
      return true
    end
  }

  uiPickerWheelConfirmButton = widget.newButton
  {
    label = "CONFIRM",
    shape = "rect",
    x = display.contentCenterX * 1.55,
    y = display.contentCenterY * 1.55,
    width = display.contentWidth * 0.4,
    height = display.contentHeight * 0.05,
    labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    fillColor = { default={ 0.4, 0.8, 0.5, 0.7 }, over={ 0.4, 0.8, 0.5, 1 } },
    emboss = true,
    onRelease = function(event)
      print('confirm button clicked')
      local values = uiPickerWheel:getValues()
      uiCategoryButton:setLabel(values[1].value)
      -- just close the picker wheel group, nothing more
      uiPickerWheelGroup.isVisible = false
      return true
    end
  }

  uiPickerWheelGroup = display.newGroup()
  uiPickerWheelGroup:insert(uiPickerWheel)
  uiPickerWheelGroup:insert(uiPickerWheelCancelButton)
  uiPickerWheelGroup:insert(uiPickerWheelConfirmButton)

  uiPickerWheelGroup.isVisible = false

end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen

  end
end


-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen

  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view

end

local function onMouseEvent( event )

  --print("event.scrollY "..event.scrollY)

  if(uiInfoTableView:getNumRows() >= 1) then
    if(event.scrollY < 0) then
      uiInfoTableViewCurrentIndex = uiInfoTableViewCurrentIndex - 1
      if(uiInfoTableViewCurrentIndex <= 1) then
        uiInfoTableViewCurrentIndex = 1
      end
    elseif(event.scrollY > 0) then
      uiInfoTableViewCurrentIndex = uiInfoTableViewCurrentIndex + 1
      if(uiInfoTableViewCurrentIndex >=  uiInfoTableView:getNumRows()) then
        uiInfoTableViewCurrentIndex = uiInfoTableView:getNumRows()
      end
    end

    if(uiInfoTableViewCurrentIndex >= 1) then
      uiInfoTableView:scrollToIndex(uiInfoTableViewCurrentIndex)
    end
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "mouse", onMouseEvent )
-- -----------------------------------------------------------------------------------

return scene