test_that("make_network - correct number of nodes, include hermits", {
  expect_equal(igraph::gorder(make_network(sample1)), 9)
})

test_that("make_network - correct number of edges for SAD1", {
  # 1-edit distance
  expect_equal(igraph::gsize(make_network(sample1)), 9)
})

test_that("make_network - correct number of edges for S1", {
  # 1-edit (sub only)
  expect_equal(igraph::gsize(make_network(sample1, neighbor_type = 'hamming')), 5)
})

test_that("make_network - correct number of edges for SAD2", {
  # 2-edit distance
  expect_equal(igraph::gsize(make_network(sample1, edit_size = 2)), 24)
})

test_that("make_network - correct number of edges for S2", {
  # 2-edit (sub only)
  expect_equal(igraph::gsize(make_network(sample1, neighbor_type = 'hamming', edit_size = 2)), 11)
})
