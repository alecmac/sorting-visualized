from skimage import color
import numpy as np
import os
import cv2

# Most of these sorting algorithms are modified from
# geekviewpoint.com's sorting implementations

'''
def bubblesort(A):
    # modified from http://www.geekviewpoint.com/python/sorting/bubblesort
    swaps = []
    for i in range(len(A)):
        for k in range(len(A) - 1, i, -1):
            if (A[k] < A[k - 1]):
                swaps.append([k, k - 1])
                tmp = A[k]
                A[k] = A[k - 1]
                A[k - 1] = tmp
    return A, swaps
    
'''
def mergesort(a):
    swaps = []

    # recursively split data until each element is isolated
    # end when two sorted halves are combined
    if len(a) > 1:
        
        # floor center to determine number of elements on L and R if len(a) is odd
        center = len(a) // 2
        left = a[:center]
        right = a[center:]

        # run function on the left and right halves of each split
        mergesort(left)
        mergesort(right)

        i = 0
        j = 0
        k = 0
        
        while i < len(left) and j < len(right):
            if left[i] < right[j]:
                a[k] = left[i]
                swaps.append([k, i])
                i = i + 1
            else:
                a[k]=right[j]
                swaps.append([k, j])
                j = j + 1
            k = k + 1

        while i < len(left):
            a[k] = left[i]
            swaps.append([k, i])
            i = i + 1
            k = k + 1

        while j < len(right):
            a[k] = right[j]
            swaps.append([k, j])
            j = j + 1
            k = k + 1
    return a, swaps


img = cv2.imread('initial_shuffled.png', 1)
img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

#in_rgb = color.convert_colorspace(img, 'HSV', 'RGB')

maxMoves = 0
moves = []

for i in range(img.shape[0]):

    _, newMoves = mergesort(list(img[i,:,0]))

    if len(newMoves) > maxMoves:
        maxMoves = len(newMoves)
    moves.append(newMoves)

currentMove = 0

def swap_pixels(row, places):
    tmp = img[row,places[0],:].copy()
    img[row,places[0],:] = img[row,places[1],:]
    img[row,places[1],:] = tmp

# 24 fps, and we want a 5 second gif 24 * 5 = 120 total frames (* 24 5)
movie_image_step = maxMoves // 360
movie_image_frame = 0


while currentMove < maxMoves:
    for i in range(img.shape[0]):
        if currentMove < len(moves[i]) - 1:
            swap_pixels(i, moves[i][currentMove])

    if currentMove % movie_image_step == 0:
        cv2.imwrite('merge%05d.png' % (movie_image_frame), cv2.cvtColor(img, cv2.COLOR_HSV2BGR))
        movie_image_frame += 1

    currentMove += 1
