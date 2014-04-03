#NPS_Park_Labels[zoom>=5]{
  [zoom=5][area_buffer_500km<2],
  [zoom=5][visitors_buffer_1000km<2],  
  [zoom=5][minzoompoly<=5],
  [zoom=6][area_buffer_250km<2],
  [zoom=5][visitors_buffer_125km<2],    
  [zoom=6][minzoompoly<=6],
  [zoom=7][area_buffer_125km<2],
  [zoom=7][visitors_buffer_125km<2],
  [zoom=7][minzoompoly<=7],
  [zoom=8][area_buffer_50km<2],
  [zoom=8][visitors_buffer_125km<2],
  [zoom=8][minzoompoly<=8],
  [zoom=9][area_buffer_50km<2],
  [zoom=9][visitors_buffer_25km<2],
  [zoom=9][minzoompoly<=9],  
  [zoom=10][area_buffer_25km<2],
  [zoom=10][visitors_buffer_25km<3],
  [zoom=10][minzoompoly<=10], 
  [zoom=11][area_buffer_250km<4],
  [zoom=11][area_buffer_125km<8],
  [zoom=11][area_buffer_25km<6],
  [zoom=11][minzoompoly<=11],
  [zoom=12][area_buffer_250km<4],
  [zoom=12][area_buffer_125km<8],
  [zoom=12][area_buffer_25km<12],
  [zoom=12][minzoompoly<=12],
  [zoom>=13]  
  {
    text-name: [name];
    text-face-name: @ft_bold;

text-size: 11;
    text-min-distance: 20;
    text-fill: #194000;
    text-halo-fill: white;
    text-halo-radius: 2;
    text-allow-overlap: true;
    text-placement-type: simple;
    text-placements: "NE,NW,SE,SW";
    text-dy: 1;
    text-dx: 1;
    text-wrap-width: 100;
    text-avoid-edges: true;
  }
}
