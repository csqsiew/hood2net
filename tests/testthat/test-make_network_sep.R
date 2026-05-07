# sample2

test_that("make_network_sep - correct number of nodes, include hermits", {
  expect_equal(igraph::gorder(make_network_sep(sample2)), 9)
})

test_that("make_network_sep - correct number of edges for SAD1", {
  # 1-edit distance
  expect_equal(igraph::gsize(make_network_sep(sample2)), 9)
})

test_that("make_network_sep - correct number of edges for S1", {
  # 1-edit (sub only)
  expect_equal(igraph::gsize(make_network_sep(sample2, neighbor_type = 'hamming')), 5)
})

test_that("make_network_sep - correct number of edges for SAD2", {
  # 2-edit distance
  expect_equal(igraph::gsize(make_network_sep(sample2, edit_size = 2)), 24)
})

test_that("make_network_sep - correct number of edges for S2", {
  # 2-edit (sub only)
  expect_equal(igraph::gsize(make_network_sep(sample2, neighbor_type = 'hamming', edit_size = 2)), 11)
})

# sample3

test_that("make_network_sep - correct number of nodes, include hermits [space separator]", {
  expect_equal(igraph::gorder(make_network_sep(sample3, separator = ' ')), 8)
})

test_that("make_network_sep - correct number of edges for SAD1 [space separator]", {
  # 1-edit distance
  expect_equal(igraph::gsize(make_network_sep(sample3, separator = ' ')), 9)
})

test_that("make_network_sep - correct number of edges for S1 [space separator]", {
  # 1-edit (sub only)
  expect_equal(igraph::gsize(make_network_sep(sample3, neighbor_type = 'hamming', separator = ' ')), 5)
})

test_that("make_network_sep - correct number of edges for SAD2 [space separator]", {
  # 2-edit distance
  expect_equal(igraph::gsize(make_network_sep(sample3, edit_size = 2, separator = ' ')), 24)
})

test_that("make_network_sep - correct number of edges for S2 [space separator]", {
  # 2-edit (sub only)
  expect_equal(igraph::gsize(make_network_sep(sample3, neighbor_type = 'hamming', edit_size = 2, separator = ' ')), 11)
})
