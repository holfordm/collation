# -*- coding: utf-8 -*-
"""
Created on Tue Apr 25 20:11:01 2017

@author: Matthew Holford
"""
#version 4 : make canvas size relative to quire size



def draw_quire(quire, quire_no, start_folio, y, texts):
    leaf_svg = ''
    
        
    #controls the distance between final y coordinate of folios
    #40 gives reasonable legibility with two inserted leaves in a row
    interval = 40
    
    
    leaves = quire[0]
    
    canvas_height = (leaves*interval) + 50
    
    #centre of quire 
    
    centre = [50, (canvas_height/2) + y]
    
    #label the quire with its number
    leaf_svg += '<text x="{}" y="{}" font-size="10">Quire {}</text>'.format(0, centre[1], quire_no)
    
    
    
    missing_leaves = quire[1]
    added_leaves = quire[2]    
    total_leaves = leaves + len(added_leaves)
    
    #define middle opening of quire
    middle = (leaves/2) +0.5 #or total_leaves?
    
       
    folio_no = start_folio
    
    #this keeps track of position relative to the original quire structure
    leaf_counter = 1

    for i in range(1, total_leaves+1):
        
        
        
        #draw a missing leaf. Do not increment folio number. Do increment leaf counter.
        if i in missing_leaves:       
            
            x1 = centre[0]
            y1 = centre[1]
            x2=x1+80
            #y coord aligns with following or previous folio. 
            #This line could be shorter.
            if leaf_counter < middle:
                y2 =  y1 - ((((leaves/2)-leaf_counter)+1)*(interval*0.75))
            else:
                y2 = y1 + ((leaf_counter-(leaves/2))*(interval*0.75))
            leaf_svg += '<line x1="{}" y1="{}" x2="{}" y2="{}" stroke-width="1" stroke="black"/>'.format(x1, y1, x2, y2)
            leaf_counter += 1
            
        #draw an added leaf. Do increment folio number.Do not increment leaf counter.
        
        elif i in added_leaves:
            #centre relative to middle of quire
            x1 = 90
            x2 = x1 + 70       
            
            #position not just based on leaf_counter any more but on i
            #say 2 leaves after quire leaf 6 (of 8) = now folios 7, 8
            #y = 150 + 40 + ?5
            #centre + (leaf_counter-leaves/2)*interval + 
            if leaf_counter < middle:
                y1 = centre[1] - ((((leaves/2)-leaf_counter)+1)*(interval*0.5))-((i-leaf_counter) *2)
                y2 =  y1 - ((((leaves/2)-leaf_counter)+1)*(interval*0.75))-((i-leaf_counter) *6)
            else:
                y1 = centre[1] + (((leaf_counter-1)-(leaves/2))*(interval*0.5)) +((i-leaf_counter)*2)
                y2 = y1 + (((leaf_counter-1)-(leaves/2))*(interval*0.75))+((i-leaf_counter)*6)
            
            leaf_svg += '<line x1="{}" y1="{}" x2="{}" y2="{}" stroke-width="1" stroke="black"/>'.format(x1, y1, x2, y2)
            
            #folio label
            x2 += 10            
            leaf_svg += '<text x="{}" y="{}" font-size="10">Fol. {}</text>'.format(x2, y2, folio_no)
            
            folio_no += 1
            
            
        #draw a normal leaf. Do increment folio number. Do increment leaf counter.
        else:
        
            x1 = centre[0]
            y1 = centre[1]
            x2=x1+100
            
        #calculate end y of leaf
        #centre y is (say) 150
        #if before middle:
        #leaf 4 of 8 leaves = 130 
        # i.e. 150 - ((leaves/2) - leaf_counter)+1)*20
        #leaf 5 of 8 = 170
        #i.e. 150 + 20, i.e. leaf_counter-leaves/2 *20 
            if leaf_counter < middle:
                y2 =  y1 - ((((leaves/2)-leaf_counter)+1)*interval)
            else:
                y2 = y1 + ((leaf_counter-(leaves/2))*interval)
            leaf_svg += '<line x1="{}" y1="{}" x2="{}" y2="{}" stroke-width="1" stroke="black"/>'.format(x1, y1, x2, y2)
        
        #add folio label
            x2 += 20
            leaf_svg += '<text x="{}" y="{}" font-size="10">Fol. {}</text>'.format(x2, y2, folio_no)
            leaf_counter += 1
            folio_no += 1
        
        #check to see if a text begins or ends
        for text in texts:
            
            if text[0] == folio_no:
                x2 += 40                
                leaf_svg += '<text x="{}" y="{}" font-size="10">Beginning of text: {}</text>'.format(x2, y2, text[1])
        
        
    return leaf_svg    
        
    
    
    
    

#==============================================================================
# #sample date 1 from Penn MS Codex 1170
# #http://openn.library.upenn.edu/Data/0002/mscodex1170/data/mscodex1170_TEI.xml
# 
# #quire data: number of leaves
# quires = [12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 4]
# 
# #text data: start folio, title
# texts = [[2, 'Sermones de tribus partibus penitencie'], 
#          [146, 'Modus confitendi'], [155, 'Brevis tractalus de statu religionis']]
# 
# 
#==============================================================================
#EL 9 h 10
#1-58 610(through f. 50) 74 86 9-308 316 322 (+3, f. 245) 33-508
#==============================================================================
# quires = [[8, [], []], [8, [], []], [8, [], []], [8, [], []], [8, [], []],
#           [10, [], []], [4, [], []], [6, [], []], [8, [], []], [8, [], []],
#         [8, [], []], [8, [], []], [8, [], []], [8, [], []], [8, [], []], [8, [], []],
#         [8, [], []], [8, [], []], [8, [], []], [8, [], []], [8, [], []],
#         [8, [], []], [8, [], []], [8, [], []], [8, [], []], [8, [], []], 
#          [8, [], []], [8, [], []], [8, [], []], [8, [], []], [6, [], []],
#         [2, [], [3]], [8, [], []], [8, [], []], [8, [], []], [8, [], []], 
#        [8, [], []], [8, [], []], [8, [], []], [8, [], []], [8, [], []],
#         [8, [], []], [8, [], []], [8, [], []],[8, [], []],[8, [], []],[8, [], []],
#         [8, [], []],[8, [], []],[8, [], []]]
#==============================================================================


#sample data
#quire = [leaves, [missing leaves], [added leaves]]
#maybe add start folio too?

ms_name = 'sample'

quires = [[8, [], [3]], [6, [5], [7]], [8, [], [7, 8]]]

texts = [[100, 100]]


#MAIN

svg = ''

svg += '''<svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%">'''

start_folio = 1
quire_no = 1
#incremental y coordinate
y=0
for quire in quires:
    svg += draw_quire(quire, quire_no, start_folio, y, texts)
    start_folio += quire[0] - len(quire[1]) + len(quire[2])
    quire_no += 1
    y += (quire[0]*40) + 100
    

svg += '</svg>'

print(svg)

#write svg to file
filename = ms_name + '.svg'
with open (filename, 'w') as f:
    print(svg, file=f)

#write html file to embed svg so we can scroll if we need to
filename = ms_name + '.html'
with open (filename, 'w') as f:
    print('''<!DOCTYPE html SYSTEM "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>Collation of {}</title>
    </head>
    <body>
    <p>Collation of {}</p>
        <object data="{}.svg" type="image/svg+xml" height="{}" width="100%"/>
            
        
    </body>
</html>'''.format(ms_name, ms_name, ms_name, y), file=f)




