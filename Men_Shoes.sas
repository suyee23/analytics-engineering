/*Importing the CSV file*/
DATA menshoes;
    INFILE '/home/u47499035/my_courses/Jia En/Men shoe prices.csv'
	DLM = "," MISSOVER DSD FIRSTOBS=2;
		 INFORMAT ID $20.;
		 INFORMAT asins $98.;
		 INFORMAT brand $37.;
		 INFORMAT categories $583.;
		 INFORMAT colours $390.;
		 INFORMAT count $1. ;
		 INFORMAT dateAdded $20.; 
		 INFORMAT dateUpdated $20.; 
		 INFORMAT descriptions $27059.;
		 INFORMAT dimension $29.;
		 INFORMAT ean $13.;
		 INFORMAT features $2150.;
		 INFORMAT flavors $1.;
		 INFORMAT imageURLs $7981.; 
		 INFORMAT isbn $1. ;
		 INFORMAT keys $527.;
		 INFORMAT manufacturer $35.;
		 INFORMAT manufacturerNumber $59.;
		 INFORMAT merchants $717.;
		 INFORMAT name $154.;
		 INFORMAT prices_amountMin BEST32.;
		 INFORMAT price_amountMax BEST32.;
		 INFORMAT prices_availability $20.;
		 INFORMAT prices_color $59.;
		 INFORMAT prices_condition $16.; 
		 INFORMAT prices_count $17.;
		 INFORMAT prices_currency $50.;
		 INFORMAT prices_dateAdded $38.;
		 INFORMAT prices_dateSeen $143.;
		 INFORMAT prices_flavor $20.;
		 INFORMAT prices_isSale $125.;
		 INFORMAT prices_merchant $250.; 
		 INFORMAT prices_offer $125.;
		 INFORMAT prices_returnPolicy $3837.;
		 INFORMAT prices_shipping $356.;
		 INFORMAT prices_size $2118.;
		 INFORMAT prices_source $480.;
		 INFORMAT prices_sourceURLs $480.;
		 INFORMAT prices_warranty $198.; 
		 INFORMAT quantities $150.;
		 INFORMAT reviews $28934. ;
		 INFORMAT sizes $4206.;
		 INFORMAT skus $555.;
		 INFORMAT sourceURLs $29828.;
		 INFORMAT upc $194.;
		 INFORMAT vin $297. ;
		 INFORMAT websiteID $107.;
		 INFORMAT weight $83.;

		 FORMAT ID $20.;
		 FORMAT asins $98.;
		 FORMAT brand $37.;
		 FORMAT categories $583.;
		 FORMAT colours $390.;
		 FORMAT count $1. ;
		 FORMAT dateAdded $20.; 
		 FORMAT dateUpdated $20.; 
		 FORMAT descriptions $27059.;
		 FORMAT dimension $29.;
		 FORMAT ean $13.;
		 FORMAT features $2150.;
		 FORMAT flavors $1.;
		 FORMAT imageURLs $7981.; 
		 FORMAT isbn $1. ;
		 FORMAT keys $527.;
		 FORMAT manufacturer $35.;
		 FORMAT manufacturerNumber $59.;
		 FORMAT merchants $717.;
		 FORMAT name $154.;
		 FORMAT prices_amountMin BEST12.;
		 FORMAT price_amountMax BEST12.;
		 FORMAT prices_availability $20.;
		 FORMAT prices_color $59.;
		 FORMAT prices_condition $16.; 
		 FORMAT prices_count $17.;
		 FORMAT prices_currency $50.;
		 FORMAT prices_dateAdded $38.;
		 FORMAT prices_dateSeen $143.;
		 FORMAT prices_flavor $20.;
		 FORMAT prices_isSale $125.;
		 FORMAT prices_merchant $250.; 
		 FORMAT prices_offer $125.;
		 FORMAT prices_returnPolicy $3837.;
		 FORMAT prices_shipping $356.;
		 FORMAT prices_size $2118.;
		 FORMAT prices_source $198.;
		 FORMAT prices_sourceURLs $480.;
		 FORMAT prices_warranty $198.; 
		 FORMAT quantities $150.;
		 FORMAT reviews $28934. ;
		 FORMAT sizes $4206.;
		 FORMAT skus $555.;
		 FORMAT sourceURLs $29828.;
		 FORMAT upc $194.;
		 FORMAT vin $297. ;
		 FORMAT websiteID $107.;
		 FORMAT weight $83.;

	INPUT
	ID $ asins $ brand $ categories $ colours $ count $ dateAdded $ dateUpdated $ 
	descriptions $ dimension $ ean $ features $ flavors $ imageURLs $ isbn $ keys $ manufacturer $ 
	manufacturerNumber $ merchants $ name $ prices_amountMin  price_amountMax  prices_availability $ 
	prices_color $ prices_condition $ prices_count $ prices_currency $ prices_dateAdded $ prices_dateSeen $
	prices_flavor $ prices_isSale $ prices_merchant $ prices_offer $ prices_returnPolicy $ prices_shipping $ prices_size $
	prices_source $ prices_sourceURLs $ prices_warrantly $ quantities $ reviews $ sizes $ skus $ sourceURLs $ upc $ vin $ websiteID $ weight $;

	KEEP ID brand features colours prices_amountMin price_amountMax prices_currency reviews;
RUN;

/*Data Validation*/
/*Observing the rows of the dataset*/
PROC PRINT DATA = work.womenshoes;
RUN; 

/*Observing the contents of the dataset*/
PROC CONTENTS DATA=work.menshoes;
RUN;

/*Observing the summary statistics of the dataset*/
PROC MEANS DATA = work.womenshoes;
RUN;

/*Identifying missing values in Brand*/
PROC FREQ DATA = work.menshoes;
	TABLES Brand / MISSING;
RUN; 

/*Identifying missing values in ID*/
PROC FREQ DATA = work.menshoes;
	TABLES ID / MISSING;
RUN; 

/*Data Cleaning*/
/*Filter Dataset by Currency*/
/*Assigning Median Shoe Price*/
DATA outputmen;
	SET work.menshoes;
	WHERE prices_currency = "USD";
	median_price = MEDIAN(prices_amountMin, price_amountMax);
RUN; 

/*Rearranging Shoe Price in Descending Order*/
PROC SORT DATA = work.outputmen OUT = descmedian_men;
	BY DESCENDING median_price;
RUN;

/*Deleting Duplicate Rows*/
PROC SORT DATA = descmedian_men OUT = nodup_men NODUPKEY;
	BY ID;
RUN;

/*Imputing values for Brand*/
DATA work.newoutput_men;
	SET work.nodup_men;
	IF brand = ' ' THEN brand = 'No Brand';
RUN;

/*Cleaning and Categorizing Colours in Men Shoes Dataset into Basic_colours and Assorted_Colours*/
DATA work.output_men;
	SET work.newoutput_men;
	ARRAY colourslist {84} $ ('Amber', 'Apricot', 'Aqua', 'Ash', 'Beige', 'Berry', 'Black', 'Blue', 'Brass', 'Bronze', 'Brown', 
                          	'Burgundy', 'Camel', 'Caramel', 'Charcoal', 'Chestnut', 'Chocolate', 'Cinnamon', 'Clear', 'Coffee', 
                          	'Cognac', 'Copper', 'Coral', 'Cream', 'Cyan', 'Fougere', 'Ginger', 'Gold', 'Green', 'Grey', 'Hashbrown', 
                          	'Heather', 'Hickory', 'Honey', 'Indigo', 'Ivory', 'Jade', 'Khaki', 'Lime', 'Magenta', 'Mahogany', 'Maroon', 
                          	'Marshmallow', 'Matte', 'Metal', 'Mocha', 'Mustard', 'Natural', 'Navy', 'Neon', 'Nero', 'Nude', 'Oatmeal', 
                          	'Olive', 'Orange', 'Peacoat', 'Peanut', 'Pearl', 'Pink', 'Purple', 'Quarry', 'Red', 'Rose', 'Sand', 'Scarlet', 
                          	'Silver', 'T-moro', 'Tan', 'Taupe', 'Teal', 'Viola', 'Violet', 'Walnut', 'Wheat', 'White', 'Wood', 'Wyoming', 
                          	'Yellow', 'Turquoise', 'Platinum', 'Pewter', 'Volt', 'Hemp');
	upcolours = UPCASE(colours);
	upcolours = COMPBL(TRANSLATE(upcolours,' ',",{}"":[]"));
	IF upcolours = 'GRAY' THEN upcolours = 'GREY';
	IF upcolours = 'BLK' OR 'BLACKS' THEN upcolours = 'BLACK';
	IF upcolours = 'NATUR' THEN upcolours = 'NATURAL';
	IF upcolours = 'TQR' THEN upcolours = 'TURQUOISE';
	IF upcolours = 'MAGNETA' THEN upcolours = 'MAGNETA';
	IF upcolours = 'CLR' THEN upcolours = 'CLEAR';
	IF upcolours = 'SMOKEY' THEN upcolours = 'SMOKY';
	DO i=1 TO 80;
		IF INDEX(upcolours, UPCASE(colourslist{i})) THEN basic_colours = 'Yes'; 
	DROP i;
	END;
	ARRAY colourslisttwo {124} $ ('Acid Fate', 'Aged Bark', 'Alabama', 'Crimson Tide', 'Alloy', 'Amber Polarized', 'Animal', 'Anthracite', 
                             		'Antique Cigar', 'AquaVizicoral', 'Arancio', 'Armor', 'Bellingham', 'Bossa', 'Bruno', 'Bubblicious', 
                            	 	'Buffalo', 'Bungee', 'Burnt Maple', 'Burnt Umber', 'Cafe', 'Cambray Swan', 'Camo', 'Camouflage', 'Cannon', 
                             		'Caraway', 'Carolina Panthers', 'Casino Casin', 'Castlerock', 'City Digital Camo', 'Coyote', 'Crocodile', 
                             		'Curry', 'Dark Sea', 'Denim', 'Desert Digital Camo', 'Designer Styles', 'Eggplant Peel', 'Emerald', 
                             		'Everglades', 'Ferro', 'Fire', 'Flower', 'Fog', 'Fuchsia', 'Gargoyte', 'Gaucho', 'Ginger Bread', 'Glitter', 
                             		'Gradient', 'Grizzly Mountain', 'Gum', 'Hamburgers', 'Havana', 'Hemlock', 'Imperial', 'Indiana Pacers', 
                             		'Java', 'Jeans', 'Lace', 'Lake', 'Late Night', 'Leather', 'Leopard', 'Levine', 'Line Forest', 'Lion', 
                             		'Magnet', 'Marine', 'Matte Cement', 'Metallic', 'Mickey Mouse', 'Mility', 'Milkshake', 'Mineral', 'Mojave', 
                             		'Mono Tomado', 'Monochrome', 'Moss', 'Mouse', 'Multi-color', 'Mushroom', 
                             		'Non-Metallic', 'Nova', 'Nut', 'Oaks', 'Onyx', 'Papyrus', 'Pesto', 'Pine', 'Polka Dot', 'Pro ocean', 'Quincy', 
                             		'Rainbow Sparkles', 'Rasta', 'Redwood', 'Ridge Reaper', 'Root Beer', 'Rosso Corsa', 'Rubylce Marine', 
                             		'Saddle', 'Salt Marsh', 'Sapphire Star', 'Snake', 'Snow White', 'Steel', 'Stone', 'Stout', 'Stripe', 
                             		'Stucco', 'Sunflower', 'Sunset', 'Tampa Bay Buccaneers', 'The Jungle Book', 'Thunder', 'Tinted', 'Toasted Wheat', 
                             		'Tortoise', 'Trail Crazy Horse', 'Turtle Dove', 'Typhon', 'Urban Digital Camo', 'Woodland Camo', 'Yeti Crazy Horse', 
                             		'Zebra');
	upcolours = UPCASE(colours);
	upcolours = COMPBL(TRANSLATE(upcolours,' ',",{}"":[]"));
	IF upcolours = 'MULTI' OR upcolours = 'MULTICOLOR' OR upcolours = 'MULTICOLORED' THEN upcolours = 'MULTI-COLOR';
	DO i=1 TO 100;
		IF INDEX(upcolours, UPCASE(colourslisttwo{i})) THEN assorted_colours = 'Yes';
	DROP i;
	END;
	KEEP ID brand features colours median_price reviews basic_colours assorted_colours;
RUN;

/*Extracting Condition from Features Attribute*/
DATA condition_men;
	SET work.output_men;
	features = COMPBL(TRANSLATE(features,' ',",{}"":[]"));
	features = TRANWRD(features,"value","");
	condition_exists = FIND(features,'Condition','i');
	key_exists = FIND(features,'key',36);
	Condition = SUBSTR(features,condition_exists,key_exists);
	Condition = TRANWRD(Condition,"Condition","");
	DROP condition_exists key_exists;
RUN;

DATA condition2_men;
	SET condition_men;
	new_exist = FIND(Condition,'New','i');
	key_exists2 = FIND(Condition,'key','i');
	IF key_exists2 ^= 0 THEN DO;
	   Condition_new = SUBSTR(Condition,new_exist,key_exists2-5);
	END;
	IF key_exists2 = 0 THEN DO;
	   Condition_new = Condition;
	END;
	DROP key_exists2 new_exist;
RUN;

/*Extracting Materials from Features Attribute*/
DATA material_men;
	SET condition2_men;
	material_exists = FIND(features,'Material','i');
	mkey_exists = FIND(features,'key',25);
	Material = SUBSTR(features,material_exists,mkey_exists);
	DROP material_exists mkey_exists;
RUN;

DATA material2_men;
	SET material_men;
	new_exist2 = FIND(Material,'Material','i');
	key_exists3 = FIND(Material,'key','i');
	IF key_exists3 ^= 0 THEN DO;
	   Material = SUBSTR(Material,new_exist2,key_exists3-1);
	END;
	IF key_exists3 = 0 THEN DO;
	   Material = Material;
	END;
	Material = TRANWRD(Material,"Material","");
	Material = TRANWRD(Material,"material","");
	Material = TRANWRD(Material,"materials","");
	KEEP ID brand colour median_price reviews basic_colours assorted_colours Condition_New Material;
RUN;

/*Exporting the dataset into CSV file for R Studio*/
PROC EXPORT DATA=work.material2_men
	OUTFILE = '/home/u47499035/my_courses/Jia En/menshoes_final.csv'
	DBMS=csv;
RUN;

/*Data Reporting*/
PROC PRINT DATA=work.material2_men;
RUN;

/*Arranging the observations with an descending sequence*/
PROC SORT DATA=work.material2_men OUT = work.mencleaned;
	BY DESCENDING brand;
RUN;

/*Showing the Top 5 Brands in Men Shoes*/
PROC FREQ DATA=work.mencleaned ORDER=freq;
	OPTIONS OBS=5;
	TABLES brand;
RUN;

/*Only Top 5 Brands are kept in the dataset*/
DATA work.mencleanedfinal (DROP=reviews);
	SET work.mencleaned;
	WHERE brand IN ("Nike", "PUMA", "Reebok", "VANS", "New Balance")
	AND (Material ^= " " OR Condition_New ^= " ");
RUN;

/*Exporting the dataset into CSV file as final dataset*/
PROC EXPORT DATA=work.mencleanedfinal
	OUTFILE = '/home/u47499035/my_courses/Jia En/menshoes_cleanedgraphfinal.csv'
	DBMS=csv;
RUN;

/*Data Visualization*/
/*Bar Chart - Men Brand*/
ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGPLOT DATA=WORK.MENCLEANEDFINAL;
	TITLE HEIGHT=14pt "Brand of Men Shoes";
	VBAR brand / DATALABEL;
	YAXIS GRID;
RUN;

ODS GRAPHICS / RESET;
TITLE;

/*Bar Chart - Men Basic Colours*/
ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGPLOT DATA=WORK.MENCLEANEDFINAL;
	TITLE HEIGHT=14pt "Men Shoes with Basic Colours";
	VBAR basic_colours / DATALABEL;
	YAXIS GRID;
RUN;

ODS GRAPHICS / RESET;
TITLE;

/*Bar Chart - Men Assorted Colours*/
ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGPLOT DATA=WORK.MENCLEANEDFINAL;
	TITLE HEIGHT=14pt "Men Shoes with Assorted Colours";
	VBAR assorted_colours / DATALABEL;
	YAXIS GRID;
RUN;

ODS GRAPHICS / RESET;
TITLE;

/*Pie Chart - Men Conditions*/
PROC TEMPLATE;
	DEFINE STATGRAPH SASStudio.Pie;
		BEGINGRAPH;
		ENTRYTITLE "Condition of Men Shoes" / TEXTATTRS=(size=14);
		LAYOUT REGION;
		PIECHART CATEGORY=Condition_new / STAT=pct DATALABELLOCATION=outside;
		ENDLAYOUT;
		ENDGRAPH;
	END;
RUN;

ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGRENDER TEMPLATE=SASStudio.Pie DATA=WORK.MENCLEANEDFINAL;
RUN;

ODS GRAPHICS / RESET;

/*Pie Chart - Men Materials*/
PROC TEMPLATE;
	DEFINE STATGRAPH SASStudio.Pie;
		BEGINGRAPH;
		ENTRYTITLE "Materials of Men Shoes" / TEXTATTRS=(size=14);
		LAYOUT REGION;
		PIECHART CATEGORY=Material / STAT=pct DATALABELLOCATION=outside;
		ENDLAYOUT;
		ENDGRAPH;
	END;
RUN;

ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGRENDER TEMPLATE=SASStudio.Pie DATA=WORK.MENCLEANEDFINAL;
RUN;

ODS GRAPHICS / RESET;

/*Box Plot - Men Shoes Median Price*/
ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGPLOT DATA=WORK.MENCLEANEDFINAL;
	TITLE HEIGHT=14pt "Box Plot of Median Price for Men Shoes";
	VBOX median_price /;
	YAXIS GRID;
RUN;

ODS GRAPHICS / RESET;
TITLE;
