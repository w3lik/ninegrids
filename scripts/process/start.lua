local process = Process("start")
process:onStart(function(this)
    this:next("setup")
end)
