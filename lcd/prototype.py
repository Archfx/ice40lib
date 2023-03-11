xmax = 160
ymax = 80

# for x in range (160):
#     for y in range (80):
#         print (x,y)

x = 0
y=0
done = True
for r in range(500):
    # if (x<160):
    if (y<79):
        # y=y+1;/
        if (x == 159):
            x=0
            y=y+1
            # print(x,y)
        else : 
            x=x+1

        print(x,y)



  
