#!/bin/bash


for x in *.*; do
  mkdir "${x%.*}" && mv "$x" "${x%.*}"
done
