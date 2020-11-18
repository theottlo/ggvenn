test_that("Venn diagram", {
  testdfA1 <- data.frame(movie=c("Finding Nemo", "Shrek", "Toy Story"),
                         rating=c(5, 3, 7))
  testdfB1 <- data.frame(movie=c("Finding Nemo", "Inception", "Toy Story"),
                         rating=c(5, 3, 6))
  expect_message(plot_venn(testdfA1, testdfB1, verbose=TRUE), "Plotting Venn diagram...")
})

test_that("Euler diagram: dfA and dfB are the same", {
  testdfA2 <- data.frame(movie=c("Finding Nemo", "Shrek", "Toy Story"),
                         rating=c(5, 3, 7))
  testdfB2 <- data.frame(movie=c("Finding Nemo", "Shrek", "Toy Story"),
                         rating=c(5, 3, 7))
  expect_warning(plot_venn(testdfA2, testdfB2, euler=TRUE, verbose=TRUE), "dfA and dfB are the same!")
})

test_that("NAs in data frame", {
  testdfA3 <- data.frame(movie=c("Finding Nemo", "Shrek", "Toy Story"),
                         rating=c(5, 3, NA))
  testdfB3 <- data.frame(movie=c("Finding Nemo", "Shrek", "Toy Story"),
                         rating=c(5, 3, NA))
  expect_message(plot_venn(testdfA3, testdfB3, euler=TRUE, verbose=TRUE), "Plotting Venn diagram...")
})
