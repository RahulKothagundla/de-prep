# LC 217 Contains Duplicate | Pattern: hash map / seen lookup, one pass
# Time: O(n)  Space: O(n)
# Brute force: two loops, O(n^2) | Sort first: O(n log n) time, O(1) or O(n) space

from typing import List

class Solution:
    def containsDuplicate(self, nums: List[int]) -> bool:
        dic = {}
        for i in nums:
            if i in dic:
                return True
            dic[i] = 0
        return False
        