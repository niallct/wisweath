# Wisweath

A tool to take weather observations and calculate the Wisden weather
index, as a measure of how good a summer is for playing cricket.

## Description

Input is currently only observations from the DTG weather station in
Cambridge.

[DTG Station](https://www.cl.cam.ac.uk/research/dtg/weather/)

The Index formula requires average daily maximum temperature, rainfall
total, sunshine total, and total number of dry days, in May to August period.

The Index is described in ``Cricket and the Weather'' by Philip Eden,
in Wisden 1999. (Wisden Cricketers' Almanack 1999, 136th edition, ed 
Matthew Engel. John Wisden & Co.)

Script works out those values, and so the index, for a given year and a few
years previously.

## Issues

The DTG dataset is raw data and has not undergone quality control. The group
advise against using raw data in statistical analysis.

There are glaring errors -- sunshine at midnight, for instance.
