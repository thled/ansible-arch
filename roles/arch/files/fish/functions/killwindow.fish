function killwindow
  xprop _NET_WM_PID | sed 's/_NET_WM_PID(CARDINAL) = //' | xargs kill -9 $0
end
