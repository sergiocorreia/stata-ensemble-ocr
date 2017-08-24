program ensemble_ocr
    syntax varlist(numeric min=2) [if] [in], GENerate(name)
    confirm new variable `generate'
    marksample touse
    //mata: data = strofreal(st_data(., "`varlist'", "`touse'"), "%20.0f")
    //mata: ans = ensemble(data)
    //mata: strtoreal(ans)
    mata: st_store(., st_addvar("double", "`generate'", 1), strtoreal(ensemble(strofreal(st_data(., "`varlist'", "`touse'"), "%20.0f"))))

    // TODO:
    // - fail if there are more digits than precision in a double
end


findfile "ftools_type_aliases.mata"
include "`r(fn)'"
//mata: mata set matastrict on

mata:

`String' ensemble_one(`StringRowVector' words)
{
    `Boolean' ok, is_tie
    `Integer' n, k, i, j, len
    `RowVector' lengths
    `String' word
    `Matrix' chars
    `RowVector' ans

    n = cols(words)
    lengths = strlen(words)
    k = mode(lengths)

    // Pad out each word AND drop words w/length not close to the mode
    j = 0
    for (i=1; i<=n; i++) {
        len = lengths[i]
        ok = len==k | len==k+1 | len==k-2 | len==k-1
        if (!ok) continue
        ++j
        // pad word by one space before (: is ascii 58; 9 is ascii 57)
        word = words[i]
        if (len!=k+1) word = ":" + word
        if (len==k-1) word = ":" + word
        if (len==k-2) word = word + "::"
        words[j] = word
    }

    n = j
    ++k // length of words is now increased by 1
    words = words[1..n]
    //assert(allof(strlen(words),k)) // comment this out for speed

    // Abort if there is only one variable left
    if (n==1) return("")
    
    // Compute characters per word
    chars = J(n, k, .)
    for (i=1; i<=n; i++) {
        chars[i, .] = ascii(words[i]) :- 48
    }

    // For each digit, compute mode, then reassemble number
    chars = chars'
    ans = J(1, k, .)
    //any_is_tie = 0
    for (i=1; i<=k; i++) {
        ans[i] = mode(chars[i, .], is_tie=.) + 48
        if (is_tie==1) return("") // any_is_tie = 1
    }
    return(subinstr(char(ans), ":", "", .))
}


// Compute mode when all the values are close to each other
// If two values are tied, returns the largest
`Integer' mode(`RowVector' values, | `Boolean' is_tie)
{
    `Integer' i, val, mode_val, pos, offset, min_val, max_val
    `RowVector' range
    `Vector' counts

    range = minmax(values)
    min_val = range[1]
    max_val = range[2]
    offset = min_val - 1
    counts = J(max_val - offset, 1, 0)

    // Update counts
    i = cols(values) + 1
    while (--i) {
        val = values[i] - offset
        counts[val] = counts[val] + 1
    }

    // Select pos of max count (faster than maxindex?)
    i = max_val - offset + 1
    mode_val = 0
    while (--i) {
        val = counts[i]
        if (val >= mode_val) {
            is_tie = val == mode_val
            mode_val = val
            pos = i
        }
    }

    return(offset + pos)
}


`StringVector' ensemble(`StringMatrix' data)
{
    `Integer' n, i
    `StringVector' ans
    n = rows(data)
    ans = J(n, 1, "")
    for (i=1; i<=n; i++) {
        ans[i] = ensemble_one(data[i, .])
    }
    return(ans)
}

end