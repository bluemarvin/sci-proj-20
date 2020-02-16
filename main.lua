function lovr.load()
  lovr.graphics.setBackgroundColor(0.0, 0.0, 0.0, 1.0)
  gTestTime = 60
  gColorChangeTime = 30
  gStartTime = -1
  gColor = 0
  gColorValue = 0
  gTrigger = false
  gTouchpad = false
  gStarted = false
end

function lovr.update()
  local trigger = lovr.headset.isDown("right", "trigger")
  local touchpad = lovr.headset.isDown("right", "touchpad")

  if trigger and not gTrigger then
    -- start
    if gStartTime < 0 then
      gStartTime = lovr.timer.getTime()
      print("rab - Start: " .. gStartTime)
    else
      print("rab - Stop")
      gStartTime = -1
      gColorValue = 0
    end
  end

  if gStartTime < 0 and touchpad and not gTouchpad then
    -- change color
    gColorValue = 0
    gColor = gColor + 1;
    if gColor > 2 then gColor = 0 end
    if gColor == 0 then
      print("rab - Color -> Black")
    elseif gColor == 1 then
      print("rab - Color -> Red")
    else
      print("rab - Color -> Blue")
    end
  end

  if gStartTime > 0 then
    local currentTime = lovr.timer.getTime()
    if (currentTime - gStartTime) > gTestTime then
      gStartTime = -1
      print("rab - Test Done")
    elseif (currentTime - gStartTime) > gColorChangeTime then
      gColorValue =  (currentTime - gStartTime) - gColorChangeTime
      if gColorValue > 1 then gColorValue = 1 end
    end
  end

  gTrigger = trigger
  gTouchpad = touchpad
end

function lovr.draw()
  if gStartTime < 0 and gColorValue == 0 then
    lovr.graphics.print('Paused...', 0, 1.7, -15)
  end
  if gColor == 0 then
    lovr.graphics.setBackgroundColor(0.0, 0.0, 0.0, 1.0)
  elseif gColor == 1 then
    lovr.graphics.setBackgroundColor(gColorValue, 0.0, 0.0, 1.0)
  else
    lovr.graphics.setBackgroundColor(0.0, 0.0, gColorValue, 1.0)
  end
end
