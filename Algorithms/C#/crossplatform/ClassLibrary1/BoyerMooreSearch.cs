/// License
/// 
/// Copyright (c) 2015 Jonathan Moore, 
///
/// This software is provided 'as-is', without any express or implied warranty. 
/// In no event will the authors be held liable for any damages arising from 
/// the use of this software.
/// 
/// Permission is granted to anyone to use this software for any purpose, 
/// including commercial applications, and to alter it and redistribute it 
/// freely, subject to the following restrictions:
///
/// 1. The origin of this software must not be misrepresented; 
/// you must not claim that you wrote the original software. 
/// If you use this software in a product, an acknowledgment in the product 
/// documentation would be appreciated but is not required.
/// 
/// 2. Altered source versions must be plainly marked as such, 
/// and must not be misrepresented as being the original software.
///
///3. This notice may not be removed or altered from any source distribution.


using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace BoyerMoore
{
    /// <summary>
    /// Class that implements Boyer-Moore and related exact string-matching algorithms
    /// </summary>
    /// <remarks>
    /// From "Handbook of exact string-matching algorithms"
    ///   by Christian Charras and Thierry Lecroq
    ///   chapter 15
    /// http://www-igm.univ-mlv.fr/~lecroq/string/node15.html#SECTION00150
    /// </remarks>
    public class BoyerMoore
  {
    private int[] m_badCharacterShift;
    private int[] m_goodSuffixShift;
    private int[] m_suffixes;
    private string m_pattern;

    /// <summary>
    /// Constructor
    /// </summary>
    /// <param name="pattern">Pattern for search</param>
    public BoyerMoore(string pattern)
    {
        try
        {
            /* Preprocessing */
            m_pattern = pattern;
            m_badCharacterShift = BuildBadCharacterShift(pattern);
            m_suffixes = FindSuffixes(pattern);
            m_goodSuffixShift = BuildGoodSuffixShift(pattern, m_suffixes);
        }
        catch (System.Exception)
        {
            
            throw;
        }
    }

    /// <summary>
    /// Build the bad character shift array.
    /// </summary>
    /// <param name="pattern">Pattern for search</param>
    /// <returns>bad character shift array</returns>
    private int[] BuildBadCharacterShift(string pattern)
    {
        try
        {
            int[] badCharacterShift = new int[256];

            Parallel.For(0, badCharacterShift.Length, c =>
            {
                badCharacterShift[c] = pattern.Length;
            });
            for (int i = 0; i < pattern.Length - 1; ++i)
                badCharacterShift[pattern[i]] = pattern.Length - i - 1;

            return badCharacterShift;
        }
        catch (System.Exception)
        {
            
            throw;
        }
    }

    /// <summary>
    /// Find suffixes in the pattern
    /// </summary>
    /// <param name="pattern">Pattern for search</param>
    /// <returns>Suffix array</returns>
    private int[] FindSuffixes(string pattern)
    {
        try
        {
            int f = 0, g;

            int patternLength = pattern.Length;
            int[] suffixes = new int[pattern.Length + 1];

            suffixes[patternLength - 1] = patternLength;
            g = patternLength - 1;
            for (int i = patternLength - 2; i >= 0; --i)
            {
                if (i > g && suffixes[i + patternLength - 1 - f] < i - g)
                    suffixes[i] = suffixes[i + patternLength - 1 - f];
                else
                {
                    if (i < g)
                        g = i;
                    f = i;
                    while (g >= 0 && (pattern[g] == pattern[g + patternLength - 1 - f]))
                        --g;
                    suffixes[i] = f - g;
                }
            }

            return suffixes;
        }
        catch (System.Exception)
        {
            
            throw;
        }
    }

    /// <summary>
    /// Build the good suffix array.
    /// </summary>
    /// <param name="pattern">Pattern for search</param>
    /// <returns>Good suffix shift array</returns>
    private int[] BuildGoodSuffixShift(string pattern, int[] suff)
    {
        try
        {
            int patternLength = pattern.Length;
            int[] goodSuffixShift = new int[pattern.Length + 1];

            for (int i = 0; i < patternLength; ++i)
                goodSuffixShift[i] = patternLength;
            int j = 0;
            for (int i = patternLength - 1; i >= -1; --i)
                if (i == -1 || suff[i] == i + 1)
                    for (; j < patternLength - 1 - i; ++j)
                        if (goodSuffixShift[j] == patternLength)
                            goodSuffixShift[j] = patternLength - 1 - i;
            for (int i = 0; i <= patternLength - 2; ++i)
                goodSuffixShift[patternLength - 1 - suff[i]] = patternLength - 1 - i;

            return goodSuffixShift;
        }
        catch (System.Exception)
        {
            
            throw;
        }
    }

    /// <summary>
    /// Return all matched of the pattern in the specified text using the .NET String.indexOf API
    /// </summary>
    /// <param name="text">text to be searched</param>
    /// <param name="startingIndex">Index at which search begins</param>
    /// <returns>IEnumerable which returns the indexes of pattern matches</returns>
    public IEnumerable<int> BCLMatch(string text, int startingIndex)
    {
            int patternLength = m_pattern.Length;
            int index = startingIndex;
            do
            {
                index = text.IndexOf(m_pattern, index, StringComparison.InvariantCultureIgnoreCase);
                if (index < 0)
                    yield break;
                yield return index;
                index += patternLength;
            } while (true);

        }
        

    /// <summary>
    /// Return all matched of the pattern in the specified text using the .NET String.indexOf API
    /// </summary>
    /// <param name="text">text to be searched</param>
    /// <returns>IEnumerable which returns the indexes of pattern matches</returns>
    public IEnumerable<int> BCLMatch(string text)
    {
        try
        {
            return BCLMatch(text, 0);
        }
        catch (System.Exception)
        {
            
            throw;
        }
    }

    /// <summary>
    /// Return all matches of the pattern in specified text using the Horspool algorithm
    /// </summary>
    /// <param name="text">text to be searched</param>
    /// <param name="startingIndex">Index at which search begins</param>
    /// <returns>IEnumerable which returns the indexes of pattern matches</returns>
    public IEnumerable<int> HorspoolMatch(string text, int startingIndex)
    {
            int patternLength = m_pattern.Length;
            int textLength = text.Length;

            /* Searching */
            int index = startingIndex;
            while (index <= textLength - patternLength)
            {
                int unmatched;
                for (
                  unmatched = patternLength - 1;
                  unmatched >= 0 && m_pattern[unmatched] == text[unmatched + index];
                  --unmatched
                  )
                {
                }

                if (unmatched < 0)
                    yield return index;

                index += m_badCharacterShift[text[unmatched + patternLength - 1]];
            }
        }

    /// <summary>
    /// Return all matches of the pattern in specified text using the Horspool algorithm
    /// </summary>
    /// <param name="text">text to be searched</param>
    /// <returns>IEnumerable which returns the indexes of pattern matches</returns>
    public IEnumerable<int> HorspoolMatch(string text)
    {
        try
        {
            return HorspoolMatch(text, 0);
        }
        catch (System.Exception)
        {
            
            throw;
        }
    }

    /// <summary>
    /// Return all matches of the pattern in specified text using the Boyer-Moore algorithm
    /// </summary>
    /// <param name="text">text to be searched</param>
    /// <param name="startingIndex">Index at which search begins</param>
    /// <returns>IEnumerable which returns the indexes of pattern matches</returns>
    public IEnumerable<int> BoyerMooreMatch(string text, int startingIndex)
    {
        try
        {
            int patternLength = m_pattern.Length;
            int textLength = text.Length;

            /* Searching */
            int index = startingIndex;
            while (index <= textLength - patternLength)
            {
                int unmatched;
                for (unmatched = patternLength - 1;
                  unmatched >= 0 && (m_pattern[unmatched] == text[unmatched + index]);
                  --unmatched
                )
                if (unmatched < 0)
                {
                    yield return index;
                    index += m_goodSuffixShift[0];
                }
                else
                        { }
                    index += Math.Max(m_goodSuffixShift[unmatched],
                      m_badCharacterShift[text[unmatched + index]] - patternLength + 1 + unmatched);
                 }
             }
            finally
            { }
            
       
    }

    /// <summary>
    /// Return all matches of the pattern in specified text using the Boyer-Moore algorithm
    /// </summary>
    /// <param name="text">text to be searched</param>
    /// <returns>IEnumerable which returns the indexes of pattern matches</returns>
    public IEnumerable<int> BoyerMooreMatch(string text)
    {
        try
        {
            return BoyerMooreMatch(text, 0);
        }
        catch (System.Exception)
        {
            
            throw;
        }
    }

    /// <summary>
    /// Return all matches of the pattern in specified text using the Turbo Boyer-Moore algorithm
    /// </summary>
    /// <param name="text">text to be searched</param>
    /// <param name="startingIndex">Index at which search begins</param>
    /// <returns>IEnumerable which returns the indexes of pattern matches</returns>
    public IEnumerable<int> TurboBoyerMooreMatch(string text, int startingIndex)
    {
        try
        {
            int patternLength = m_pattern.Length;
            int textLength = text.Length;

            /* Searching */
            int index = startingIndex;
            int overlap = 0;
            int shift = patternLength;
            while (index <= textLength - patternLength)
            {
                int unmatched = patternLength - 1;

                while (unmatched >= 0 && (m_pattern[unmatched] == text[unmatched + index]))
                {
                    --unmatched;
                    if (overlap != 0 && unmatched == patternLength - 1 - shift)
                        unmatched -= overlap;
                }

                if (unmatched < 0)
                {
                    yield return index;
                    shift = m_goodSuffixShift[0];
                    overlap = patternLength - shift;
                }
                else
                {
                    int matched = patternLength - 1 - unmatched;
                    int turboShift = overlap - matched;
                    int bcShift = m_badCharacterShift[text[unmatched + index]] - patternLength + 1 + unmatched;
                    shift = Math.Max(turboShift, bcShift);
                    shift = Math.Max(shift, m_goodSuffixShift[unmatched]);
                    if (shift == m_goodSuffixShift[unmatched])
                        overlap = Math.Min(patternLength - shift, matched);
                    else
                    {
                        if (turboShift < bcShift)
                            shift = Math.Max(shift, overlap + 1);
                        overlap = 0;
                    }
                }

                index += shift;
            }
        }
        finally 
        {
            
            
        }
        }
       
  

    /// <summary>
    /// Return all matches of the pattern in specified text using the Turbo Boyer-Moore algorithm
    /// </summary>
    /// <param name="text">text to be searched</param>
    /// <returns>IEnumerable which returns the indexes of pattern matches</returns>
    public IEnumerable<int> TurboBoyerMooreMatch(string text)
    {
        try
        {
            return TurboBoyerMooreMatch(text, 0);
        }
        catch (System.Exception)
        {
            
            throw;
        }
    }

    /// <summary>
    /// Return all matches of the pattern in specified text using the Apostolico-GiancarloMatch algorithm
    /// </summary>
    /// <param name="text">text to be searched</param>
    /// <param name="startingIndex">Index at which search begins</param>
    /// <returns>IEnumerable which returns the indexes of pattern matches</returns>
    public IEnumerable<int> ApostolicoGiancarloMatch(string text, int startingIndex)
    {
        try
        {
            int patternLength = m_pattern.Length;
            int textLength = text.Length;
            int[] skip = new int[patternLength];
            int shift;

            /* Searching */
            int index = startingIndex;
            while (index <= textLength - patternLength)
            {
                int unmatched = patternLength - 1;
                while (unmatched >= 0)
                {
                    int skipLength = skip[unmatched];
                    int suffixLength = m_suffixes[unmatched];
                    if (skipLength > 0)
                        if (skipLength > suffixLength)
                        {
                            if (unmatched + 1 == suffixLength)
                                unmatched = (-1);
                            else
                                unmatched -= suffixLength;
                            break;
                        }
                        else
                        {
                            unmatched -= skipLength;
                            if (skipLength < suffixLength)
                                break;
                        }
                    else
                    {
                        if (m_pattern[unmatched] == text[unmatched + index])
                            --unmatched;
                        else
                            break;
                    }
                }
                if (unmatched < 0)
                {
                    yield return index;
                    skip[patternLength - 1] = patternLength;
                    shift = m_goodSuffixShift[0];
                }
                else
                {
                    skip[patternLength - 1] = patternLength - 1 - unmatched;
                    shift = Math.Max(m_goodSuffixShift[unmatched],
                      m_badCharacterShift[text[unmatched + index]] - patternLength + 1 + unmatched
                      );
                }
                index += shift;

                for (int copy = 0; copy < patternLength - shift; ++copy)
                    skip[copy] = skip[copy + shift];

                for (int clear = 0; clear < shift; ++clear)
                    skip[patternLength - shift + clear] = 0;
            }
        }
        finally 
        {
            
            
        }
    }

    /// <summary>
    /// Return all matches of the pattern in specified text using the Apostolico-GiancarloMatch algorithm
    /// </summary>
    /// <param name="text">text to be searched</param>
    /// <returns>IEnumerable which returns the indexes of pattern matches</returns>
    public IEnumerable<int> ApostolicoGiancarloMatch(string text)
    {
        try
        {
            return ApostolicoGiancarloMatch(text, 0);
        }
        catch (System.Exception)
        {
            
            throw;
        }
    }
  }
}
