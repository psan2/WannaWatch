def 3D_glasses_animation

    10.times do 
        i = 1 
        while i < 43
            print "\033[2J" 
            File.foreach("ascii_animation/#{i}.rb")
            sleep(0.1)
            i += 1 
        end 
end 