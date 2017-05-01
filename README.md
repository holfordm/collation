# collation

A simple python script for visualizing manuscript collation.

Quires are modelled as a list of lists with each quire being a list:
[{number of leaves in original quires structure}, [{a list of missing leaves numbered by their original position}],
[{a list of added leaves numbered by their current position in the quire}]]

For example:
1(12)(-1, 7) would be: [12, [1, 7], []]
25(4)(+5) would be: [4, [], 5]

Texts in the manuscript are modelled as a list of lists with each text being a list:
[{starting folio}, {text title}]
For example, the texts described http://www.digital-scriptorium.org/huntington/EL9H9.html could be modelled:
[[1, 'Giles of Rome, De regimine principum'], [97, 'Subject index to art. 1'], [105, 'Nicholas Trivet, Commentary on Boethius's 
De consolatione philosophiae'], [192, 'Treatise on metrics']] 

The modelling is currently done in the python script. Output is two files: '{manuscript_name}.svg' containing an SVG rendering of 
the collation and '{manuscript_name}.html' providing an HTML wrapper for the SVG to allow scrolling. 

The script is under development and has been tested on a limited range of samples. 
