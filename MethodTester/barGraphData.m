function [h] = barGraphData(data,labels,myTitle)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
h = bar(data);
title(myTitle);
set(gca,'XTickLabel',labels);
end

