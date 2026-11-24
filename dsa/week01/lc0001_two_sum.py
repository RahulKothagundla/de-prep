# LC 1 Two Sum | Pattern: hash map, one pass
# Time: O(n)  Space: O(n)
# Brute force: two loops, O(n^2)
class Solution:
    def twoSum(self, nums, target):
        d = {}
        for i,j in enumerate(nums):
            if target - j in d:
                return [i, d[target-j]] 
            else:
                d[j] = i 

        return -1

