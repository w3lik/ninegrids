local process = Process("ihen")
process:onStart(function(this)
    this:next("enter")
end)
