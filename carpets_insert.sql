-- Corrected INSERT for the 16 carpet/rug products.
-- Image paths matched to the REAL filenames in src/main/webapp/assets/rugs/
-- (your original list used 'rug-01.jpg' style names with a dash and zero-padding,
--  but the actual files are named rug1.jpeg, rug2.jpeg ... rug16.jpg with no dash)

USE jcart_web_app;

INSERT INTO products (name, type, weartype, price, image) VALUES
('Moroccan Sunset Medallion Rug',    'Living Room', 'Persian',          27999.00, 'assets/rugs/rug1.jpeg'),
('Milano Trellis Wool Rug',          'Living Room', 'Modern Geometric', 21999.00, 'assets/rugs/rug2.jpeg'),
('Cascade Abstract Area Rug',        'Living Room', 'Modern Geometric', 18999.00, 'assets/rugs/rug3.jpeg'),
('Bordeaux Medallion Rug',           'Living Room', 'Persian',          23999.00, 'assets/rugs/rug4.jpeg'),
('Sienna Heritage Rug',              'Living Room', 'Persian',          19999.00, 'assets/rugs/rug5.jpeg'),
('Ivory Damask Rug',                 'Living Room', 'Persian',          22999.00, 'assets/rugs/rug6.jpg'),
('Andalusia Sunburst Rug',           'Living Room', 'Persian',          26999.00, 'assets/rugs/rug7.jpg'),
('Dune Ombre Plain Rug',             'Living Room', 'Handwoven Wool',   15999.00, 'assets/rugs/rug8.jpg'),
('Willow Floral Medallion Rug',      'Bedroom',     'Persian',          17999.00, 'assets/rugs/rug9.jpg'),
('Sandstone Solid Weave Rug',        'Living Room', 'Handwoven Wool',   13999.00, 'assets/rugs/rug10.jpg'),
('Camden Traditional Medallion Rug', 'Living Room', 'Persian',          20999.00, 'assets/rugs/rug11.jpg'),
('Hampton Vintage Medallion Rug',    'Living Room', 'Persian',          20999.00, 'assets/rugs/rug12.jpg'),
('Windsor Classic Persian Rug',      'Living Room', 'Persian',          28999.00, 'assets/rugs/rug13.jpg'),
('Nomad Handwoven Tribal Rug',       'Living Room', 'Kilim',            24999.00, 'assets/rugs/rug14.jpg'),
('Cloud Soft Shag Rug',              'Bedroom',     'Shag',             12999.00, 'assets/rugs/rug15.jpg'),
('Kensington Oriental Border Rug',   'Living Room', 'Persian',          31999.00, 'assets/rugs/rug16.jpg');

-- Bonus: 5 extra images you have (rug17-21) that weren't in your original list.
-- Uncomment / edit if you want to use them too:
-- INSERT INTO products (name, type, weartype, price, image) VALUES
-- ('Product Name Here', 'Living Room', 'Persian', 19999.00, 'assets/rugs/rug17.jpg'),
-- ('Product Name Here', 'Living Room', 'Persian', 19999.00, 'assets/rugs/rug18.jpg'),
-- ('Product Name Here', 'Living Room', 'Persian', 19999.00, 'assets/rugs/rug19.jpg'),
-- ('Product Name Here', 'Living Room', 'Persian', 19999.00, 'assets/rugs/rug20.webp'),
-- ('Product Name Here', 'Living Room', 'Persian', 19999.00, 'assets/rugs/rug21.png');
