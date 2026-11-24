# LC 242 Valid Anagram | Pattern: hash map / frequency counter
# Time: O(n)  Space: O(1) (at most 26 lowercase letters; O(n) for arbitrary Unicode)
# Brute force / Sort: sorted(s) == sorted(t), O(n log n) time, O(n) space

from collections import Counter
class Solution:
    def isAnagram(self, s: str, t: str) -> bool:
        return Counter(s) == Counter(t)


