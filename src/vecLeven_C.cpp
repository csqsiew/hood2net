#include <vector>
#include <algorithm>
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
int vecLeven_C(CharacterVector s, CharacterVector t) {

    std::vector<std::vector<int>> d(s.length() + 1, std::vector<int>(t.length() + 1, 0));

    for (int i = 0; i <= s.length(); ++i) {
        d[i][0] = i;
    }
    for (int j = 0; j <= t.length(); ++j) {
        d[0][j] = j;
    }

    for (size_t i = 0; i < s.length(); ++i) {
        for (size_t j = 0; j < t.length(); ++j) {
            d[i + 1][j + 1] = std::min({
                d[i][j + 1] + 1, // deletion
                d[i + 1][j] + 1, // insertion
                d[i][j] + (s[i] == t[j] ? 0 : 1) // substitution
            });
        }
    }

    return d[s.length()][t.length()];
}

