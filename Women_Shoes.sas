/*Importing the CSV file*/
DATA work.womenshoes;
    INFILE '/home/u47499035/my_courses/Jia En/Women shoe prices.csv'
	DLM = "," MISSOVER DSD FIRSTOBS=2;
		 INFORMAT ID $20.;
		 INFORMAT asins $98.;
		 INFORMAT brand $40.;
		 INFORMAT categories $498.;
		 INFORMAT colours $448.;
		 INFORMAT count $1. ;
		 INFORMAT dateAdded $20.; 
		 INFORMAT dateUpdated $20.; 
		 INFORMAT descriptions $25374.;
		 INFORMAT dimension $37.;
		 INFORMAT ean $11.;
		 INFORMAT features $1792.;
		 INFORMAT flavors $1.;
		 INFORMAT imageURLs $3158.; 
		 INFORMAT isbn $1. ;
		 INFORMAT keys $556.;
		 INFORMAT manufacturer $33.;
		 INFORMAT manufacturerNumber $94.;
		 INFORMAT merchants $777.;
		 INFORMAT name $279.;
		 INFORMAT prices_amountMin BEST32.;
		 INFORMAT price_amountMax BEST32.;
		 INFORMAT prices_availability $20.;
		 INFORMAT prices_color $54.;
		 INFORMAT prices_condition $16.; 
		 INFORMAT prices_count $12.;
		 INFORMAT prices_currency $30.;
		 INFORMAT prices_dateAdded $52.;
		 INFORMAT prices_dateSeen $24.;
		 INFORMAT prices_flavor $20.;
		 INFORMAT prices_isSale $86.;
		 INFORMAT prices_merchant $62.; 
		 INFORMAT prices_offer $101.;
		 INFORMAT prices_returnPolicy $7787.;
		 INFORMAT prices_shipping $109.;
		 INFORMAT prices_size $36.;
		 INFORMAT prices_source $83.;
		 INFORMAT prices_sourceURLs $360.;
		 INFORMAT prices_warranty $109.; 
		 INFORMAT quantities $124.;
		 INFORMAT reviews $29049. ;
		 INFORMAT sizes $238.;
		 INFORMAT skus $945.;
		 INFORMAT sourceURLs $17312.;
		 INFORMAT upc $109.;
		 INFORMAT websiteID $8.;
		 INFORMAT weight $85.;

		 FORMAT ID $20.;
		 FORMAT asins $98.;
		 FORMAT brand $40.;
		 FORMAT categories $498.;
		 FORMAT colours $448.;
		 FORMAT count $1. ;
		 FORMAT dateAdded $20.; 
		 FORMAT dateUpdated $20.; 
		 FORMAT descriptions $25374.;
		 FORMAT dimension $37. ;
		 FORMAT ean $11.;
		 FORMAT features $1792.;
		 FORMAT flavors $1.;
		 FORMAT imageURLs $3158.; 
		 FORMAT isbn $1. ;
		 FORMAT keys $556.;
		 FORMAT manufacturer $33.;
		 FORMAT manufacturerNumber $94.;
		 FORMAT merchants $777.;
		 FORMAT name $279.;
		 FORMAT prices_amountMin BEST12.;
		 FORMAT price_amountMax BEST12.;
		 FORMAT prices_availability $20.;
		 FORMAT prices_color $54.;
		 FORMAT prices_condition $16.; 
		 FORMAT prices_count $12.;
		 FORMAT prices_currency $30.;
		 FORMAT prices_dateAdded $52.;
		 FORMAT prices_dateSeen $24.;
		 FORMAT prices_flavor $20.;
		 FORMAT prices_isSale $86.;
		 FORMAT prices_merchant $62.; 
		 FORMAT prices_offer $101.;
		 FORMAT prices_returnPolicy $7787.;
		 FORMAT prices_shipping $109.;
		 FORMAT prices_size $36.;
		 FORMAT prices_source $83.;
		 FORMAT prices_sourceURLs $360.;
		 FORMAT prices_warranty $109.; 
		 FORMAT quantities $124.;
		 FORMAT reviews $29049. ;
		 FORMAT sizes $238.;
		 FORMAT skus $945.;
		 FORMAT sourceURLs $17312.;
		 FORMAT upc $109.;
		 FORMAT websiteID $8.;
		 FORMAT weight $85.;

	INPUT
	ID $ asins $ brand $ categories $ colours $ count $ dateAdded $ dateUpdated $ 
	descriptions $ dimension $ ean $ features $ flavors $ imageURLs $ isbn $ keys $ manufacturer $ 
	manufacturerNumber $ merchants $ name $ prices_amountMin  price_amountMax  prices_availability $ 
	prices_color $ prices_condition $ prices_count $ prices_currency $ prices_dateAdded $ prices_dateSeen $
	prices_flavor $ prices_isSale $ prices_merchant $ prices_offer $ prices_returnPolicy $ prices_shipping $ prices_size $
	prices_source $ prices_sourceURLs $ prices_warranty $ quantities $ reviews $ sizes $ skus $ sourceURLs $ upc $ websiteID $ weight $;
	KEEP ID brand features colours prices_amountMin price_amountMax prices_currency reviews;
RUN;

/* Data Validation*/
/*Observing the rows of the dataset*/
PROC PRINT DATA = work.womenshoes;
RUN; 

/*Observing the contents of the dataset*/
PROC CONTENTS DATA = work.womenshoes;
RUN; 

/*Observing the summary statistics of the dataset*/
PROC MEANS DATA = work.womenshoes;
RUN; 

/*Identifying missing values in Brand*/
PROC FREQ DATA = work.womenshoes;
	TABLES brand /MISSING;
RUN; 

/*Identifying missing values in ID*/
PROC FREQ DATA = work.womenshoes;
	TABLES ID / MISSING;
RUN; 

/*Data Cleaning*/
/*Filter Dataset by Currency*/
/*Assigning Median Shoe Price*/
DATA outputwomen;
SET work.womenshoes;
	WHERE prices_currency = "USD";
    median_price = MEDIAN(prices_amountMin, price_amountMax);
RUN; 

/*Rearranging Shoe Price in Descending Order*/
PROC SORT DATA = work.outputwomen OUT = descmedian_women;
	BY DESCENDING median_price;
RUN;

/*Deleting Duplicate Rows*/
PROC SORT DATA = descmedian_women OUT = nodup_women NODUPKEY;
	BY ID;
RUN;

/*Imputing values for Brand*/
DATA work.newoutput_women;
	SET work.nodup_women;
	IF brand = ' ' THEN brand = 'No Brand';
RUN;

/*Cleaning and Categorizing Colours in Men Shoes Dataset into Basic_colours and Assorted_Colours*/
DATA output_women;
	SET work.newoutput_women;
	ARRAY colourslist {201} $ ('Blue', 'Grey', 'Red', 'Ash', 'Black', 'Natural', 'White', 'Pink', 'Purple', 
							'Brown', 'Gold', 'Aqua', 'Coral', 'Green', 'Silver', 'Lime', 'Olive', 'Teal', 'Orange', 'Beige', 
							'Turquoise', 'Graphite', 'Ivory', 'Charcoal', 'Burgundy', 'Flesh', 'Wheat', 'Clearwater', 
							'Khaki', 'Cream', 'Violet', 'Chestnut', 'Taupe', 'Sand', 'Sahara', 'Peyote', 'Orchid', 'Rose', 'Oak', 
							'Oatmeal', 'Nude', 'Rust', 'Magenta', 'Sangria', 'Mint', 'Seafoam', 'Peanut', 'Espresso', 
							'Tumbleweed', 'Lemon', 'Mauve', 'Honey', 'Indigo', 'Hickory', 'Chocolate', 'Stone', 'Wine', 'Lilac', 
							'Grapefruit', 'Moonlight', 'Fawn', 'Driftwood', 'Marsala', 'Cornsilk', 'Fog', 'Wood', 'Dove', 'Maroon', 
							'Berry', 'Garnet', 'Praline', 'Cork', 'Pony', 'Cement', 'Cognac', 'Piedra', 'Dew', 'Plum', 'Camelot', 
							'Caramel', 'Cinnamon', 'Cocoa', 'Clear', 'Crimson', 'Eclipse', 'Blanco', 'Blond', 'Lavender', 
							'Midnight', 'Bluebelle', 'Blush', 'Bone', 'Bordeaux', 'Chartreuse', 'Bungee Cord', 'Cherry', 'Chipmunk', 
							'Lila', 'Mora', 'Rioja', 'Sorbet', 'Brunette', 'Buckskin', 'Cape', 'Camel', 'Snuff', 'Caribbean', 'Cashmere', 
							'Caviar', 'Zinfandel', 'Cayenne', 'Cerise', 'Chai Latte', 'Azure', 'Winter Garden', 'Hazelnut', 'Iris', 
							'Chambray', 'Andorra', 'Champagne', 'Sea Glass', 'Mahogany', 'Oxford', 'Vanilla', 'Evergreen', 'Smoky', 
							'Citron', 'Transparent', 'Cloud', 'Clove', 'Cocoon', 'Coffee', 'Obsidian', 'Marine', 'Cordovan', 'Drop Cloth', 
							'Eggplant', 'Peach-rose', 'Zephyr', 'Havana', 'Fossil', 'Damask', 'Hunter', 'Steel', 'Latte', 'Mercury', 'Grape', 
							'Moccasin', 'Heather', 'Garnet', 'Hyper Melon', 'Ink Shadow', 'Ice', 'Chianti', 'Jade', 'Java', 'Jewel', 'Lagoon', 
							'Chambray', 'Sage', 'Pumpkin', 'Maple', 'Marsala', 'Matte', 'Meteorite', 'Midnight Garden', 'Mine Shaft', 
							'Mustard', 'Navy', 'Rum', 'Nightfall', 'Nero', 'Noisette', 'Onyx', 'Opaline', 'Tomato', 'Peltro', 'Pearled', 
							'Petal', 'Pomegranate', 'Quarry', 'Orch', 'Rawhide', 'Robin Egg', 'Rosso', 'Ruby', 'Salmon', 'Sapphire', 
							'Scarlet', 'Sequoia', 'Serpentine', 'Sorrento', 'Sundance', 'Sunlight', 'Sunny', 'Tangerine', 'Tobacco', 
							'Turbulence', 'Vaquetta', 'Whiskey', 'Yam');
	upcolours = UPCASE(colours);
	upcolours = COMPBL(TRANSLATE(upcolours,' ',",{}"":[]"));
	IF upcolours = 'BLK' THEN upcolours = 'BLACK';
	IF upcolours = 'NATUR' THEN upcolours = 'NATURAL';
	IF upcolours = 'TQR' THEN upcolours = 'TURQUOISE';
	IF upcolours = 'MAGNETA' THEN upcolours = 'MAGENTA';
	IF upcolours = 'CLR' THEN upcolours = 'CLEAR';
	IF upcolours = 'SMOKEY' THEN upcolours = 'SMOKY';
	DO i=1 TO 201;
		IF INDEX(upcolours, UPCASE(colourslist{i})) THEN basic_colours = 'Yes';
		DROP i;
	END;
	ARRAY colourslisttwo {126} $ ('Ink', 'Marble', 'Print', 'Multi-color', 'Alloy', 'Pewter', 'Bronze', 
								'Floral', 'Platinum', 'Camouflage', 'Metallic', 'Snakeskin', 'Crocodile', 
								'Dot', 'Daisy', 'Periwinkle', 'Fuchsia', 'Tulip', 'Glitter', 'Rinse', 'Diamond', 
								'Nickel', 'Medium Wash', 'Leopard', 'Hounds', 'Herring', 'Denim', 
								'Leather', 'Zig Zag', 'Zebra', 'Sparkle', 'Satin', 'Galaxy', 'Lace', 'Dalmatian', 
								'Patent', 'Pearl', 'Mesh', 'Reptile', 'Sheepskin', 'Embroidery', 'Suede', 'Fur', 'Checkers', 
								'Cheetah', 'Goat', 'Ocelot', 'Lizard', 'Splatter', 'Eggshell', 'Poppies', 'Brindle', 'Plaid', 
								'Stucco', 'Gunmetal', 'Bulldog', 'Dragon', 'Panthers', 'Sunflower', 'Medieval', 'Renaissance', 
								'Donald Duck', 'Hydrangea', 'Wool', 'Chinchilla', 'Stripe', 'Combo', 'Copper', 'Cornflower', 
								'Poker Chips', 'Dice', 'Hearts', 'Balloons', 'Clovers', 'Peace', 'Off-white', 'Ombre', 'Herringbone', 
								'Dark Rinse', 'Tortoise', 'Distressed', 'Doe', 'Dog Face', 'Sky High Giraffe', 'Astronaut', 
								'Alpaca Couples', 'Cat Iceberg', 'Squirrel Ice Cream', 'Cat', 'Dolphin', 'Ebano', 'Humo', 
								'Dynasty', 'Faded', 'Cross', 'Elk', 'Fluorescent', 'Puppy', 'Rex', 'Koala', 'Frog', 'Sequins', 
								'Flannel', 'Shimmers', 'Greek Roman', 'Hawaii Dream', 'Melon Quake', 'Henna', 'Hodgepodge', 
								'Hologram', 'Indian Maze', 'Disney Mickey Mouse', 'Kangaroo Pockets', 'Passionflower', 
								'Mirror', 'Hair', 'Lips', 'Lipstick', 'Lux Satin', 'Galileo', 'Mixed', 'Monarch', 'Night Poppy', 
								'Tie Dye', 'Stainless Steel', 'Topaz');
	upcolours = UPCASE(colours);
	upcolours = COMPBL(TRANSLATE(upcolours,' ',",{}"":[]"));
	IF upcolours = 'MULTI' OR upcolours = 'MULTICOLOR' OR upcolours = 'MULTICOLORED' THEN upcolours = 'MULTI-COLOR';
	IF upcolours = 'PEWT' THEN upcolours = 'PEWTER';
	IF upcolours = 'FUSHIA' THEN upcolours = 'FUCHSIA';
	IF upcolours = 'CROCO' THEN upcolours = 'CROCODILE';
	IF upcolours = 'CAMO' THEN upcolours = 'CAMOUFLAGE';
	IF upcolours = 'PAT' THEN upcolours = 'PATENT';
	IF upcolours = 'FLUO' THEN upcolours = 'FLUORESCENT';
	IF upcolours = 'MICKEY' THEN upcolours = 'DISNEY MICKEY MOUSE';
	DO i=1 TO 126;
		IF INDEX(upcolours, UPCASE(colourslisttwo{i})) THEN assorted_colours = 'Yes';
		DROP i;
	END;
    KEEP ID brand features colours median_price reviews basic_colours assorted_colours;
RUN;

/*Extracting Condition from Features Attribute*/
DATA condition_women;
	SET work.output_women;
    features = COMPBL(TRANSLATE(features,' ',",{}"":[]"));
	features = TRANWRD(features,"value","");
	condition_exists = FIND(features,'Condition','i');
	key_exists = FIND(features,'key',36);
	Condition = SUBSTR(features,condition_exists,key_exists);
	Condition = TRANWRD(Condition,"Condition","");
	DROP condition_exists key_exists;
RUN;

DATA condition2_women;
	SET condition_women;
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
DATA material_women;
	SET condition2_women;	
	material_exists = FIND(features,'Material','i');
	mkey_exists = FIND(features,'key',25);
	Material = SUBSTR(features,material_exists,mkey_exists);
	DROP material_exists mkey_exists;
RUN;

DATA material2_women;
	SET material_women;
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
	KEEP ID brand colour reviews median_price basic_colours assorted_colours Condition_New Material;
RUN;

/*Exporting the dataset into CSV file for R Studio*/
PROC EXPORT DATA=work.material2_women
	OUTFILE = '/home/u47499035/my_courses/Jia En/womenshoes_cleanedfinal.csv'
	DBMS=csv;
RUN;

/*Data Reporting*/
PROC PRINT DATA=work.material2_women;
RUN;

/*Arranging the observations with an descending sequence*/
PROC SORT DATA=work.material2_women 
	OUT = work.womencleaned;
	BY DESCENDING brand;
RUN;

/*Showing the Top 5 Brands in Women Shoes*/
PROC FREQ DATA=work.womencleaned ORDER=freq;
	OPTIONS OBS=5;
	TABLES brand;
RUN;

/*Only Top 5 Brands are kept in the dataset*/
DATA work.womencleanedfinal (DROP=reviews);
	SET work.womencleaned;
	WHERE brand in ("Nike", "TOMS", "Nine West", "PleaserUSA", "Easy Spirit")
	AND (Material ^= " " OR Condition_New ^= " ");
RUN;

/*Exporting the dataset into CSV file as final dataset*/
PROC EXPORT DATA=work.womencleanedfinal
	OUTFILE = '/home/u47499035/my_courses/Jia En/womenshoes_cleanedgraphfinal.csv'
	DBMS=csv;
RUN;

/*Data Visualization*/
/*Bar Chart - Women Brand*/
ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGPLOT DATA=WORK.WOMENCLEANEDFINAL;
	TITLE HEIGHT=14pt "Brand of Women Shoes";
	VBAR brand / DATALABEL;
	YAXIS GRID;
RUN;

ODS GRAPHICS / RESET;
TITLE;

/*Bar Chart - Women Assorted Colours*/
ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGPLOT DATA=WORK.WOMENCLEANEDFINAL;
	TITLE HEIGHT=14pt "Women Shoes with Assorted Colours";
	VBAR assorted_colours / DATALABEL;
	YAXIS GRID;
RUN;

ODS GRAPHICS / RESET;
TITLE;

/*Bar Chart - Women Basic Colours*/
ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGPLOT DATA=WORK.WOMENCLEANEDFINAL;
	TITLE HEIGHT=14pt "Women Shoes with Basic Colours";
	VBAR basic_colours / DATALABEL;
	YAXIS GRID;
RUN;

ODS GRAPHICS / RESET;
TITLE;

/*Pie Chart - Women Conditions*/
PROC TEMPLATE;
	DEFINE STATGRAPH SASStudio.Pie;
		BEGINGRAPH;
		ENTRYTITLE "Conditions of Women Shoes" / TEXTATTRS=(size=14);
		LAYOUT REGION;
		PIECHART CATEGORY=Condition_new / STAT=pct DATALABELLOCATION=outside;
		ENDLAYOUT;
		ENDGRAPH;
	END;
RUN;

ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGRENDER TEMPLATE=SASStudio.Pie DATA=WORK.WOMENCLEANEDFINAL;
RUN;

ODS GRAPHICS / RESET;

/*Pie Chart - Women Materials*/
PROC TEMPLATE;
	DEFINE STATGRAPH SASStudio.Pie;
		BEGINGRAPH;
		ENTRYTITLE "Materials of Women Shoes" / TEXTATTRS=(size=14);
		LAYOUT REGION;
		PIECHART CATEGORY=Material / STAT=pct DATALABELLOCATION=outside;
		ENDLAYOUT;
		ENDGRAPH;
	END;
RUN;

ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGRENDER TEMPLATE=SASStudio.Pie DATA=WORK.WOMENCLEANEDFINAL;
RUN;

ODS GRAPHICS / RESET;

/*Box Plot - Women Shoes Median Price*/
ODS GRAPHICS / RESET WIDTH=6.4in HEIGHT=4.8in IMAGEMAP;

PROC SGPLOT DATA=WORK.WOMENCLEANEDFINAL;
	TITLE HEIGHT=14pt "Box Plot of Median Price for Women Shoes";
	VBOX median_price /;
	YAXIS GRID;
RUN;

ODS GRAPHICS / RESET;
TITLE;