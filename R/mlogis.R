

######################################
## Modify in tzhVanilla package!!
######################################



#' @title Multinomial Probabilities & Logits
#' 
#' @description 
#' 
#' Performs transformation between \link[base]{vector}s of multinomial probabilities and multinomial logits.
#' 
#' This transformation is a generalization of \link[stats]{plogis} which converts scalar logit into probability
#' and \link[stats]{qlogis} which converts probability into scalar logit.
#' 
#' @param p \link[base]{numeric} \link[base]{vector}, multinomial probabilities, adding up to 1
#' 
#' @param q \link[base]{numeric} \link[base]{vector}, multinomial logits
#' 
#' @details 
#' 
#' Functions [pmlogis_first] and [pmlogis_last] take a length \eqn{k-1} \link[base]{numeric} \link[base]{vector} of 
#' multinomial logits \eqn{q} and convert them into length \eqn{k} multinomial probabilities \eqn{p}, 
#' regarding the first or last category as reference, respectively.
#' 
#' Functions [qmlogis_first] and [qmlogis_last] take a length \eqn{k} \link[base]{numeric} \link[base]{vector} of 
#' multinomial probabilities \eqn{p} and convert them into length \eqn{k-1} multinomial logits \eqn{q}, 
#' regarding the first or last category as reference, respectively.
#' 
#' @returns 
#' 
#' Functions [pmlogis_first] and [pmlogis_last] return a \link[base]{vector} of multinomial probabilities \eqn{p}.
#' 
#' Functions [qmlogis_first] and [qmlogis_last] return a \link[base]{vector} of multinomial logits \eqn{q}.
#'
#' @seealso 
#' \link[stats]{plogis} \link[stats]{qlogis}
#'   
#' @examples
#' (a = qmlogis_last(c(2,5,3)))
#' (b = qmlogis_first(c(2,5,3)))
#' pmlogis_last(a)
#' pmlogis_first(b)
#' 
#' q0 = .8300964
#' (p1 = pmlogis_last(q0))
#' (q1 = qmlogis_last(p1))
#' 
#' # various exceptions
#' pmlogis_first(qmlogis_first(c(1, 0)))
#' pmlogis_first(qmlogis_first(c(0, 1)))
#' pmlogis_first(qmlogis_first(c(0, 0, 1)))
#' pmlogis_first(qmlogis_first(c(0, 1, 0, 0)))
#' pmlogis_first(qmlogis_first(c(1, 0, 0, 0)))
#' pmlogis_last(qmlogis_last(c(1, 0)))
#' pmlogis_last(qmlogis_last(c(0, 1)))
#' pmlogis_last(qmlogis_last(c(0, 0, 1)))
#' pmlogis_last(qmlogis_last(c(0, 1, 0, 0)))
#' pmlogis_last(qmlogis_last(c(1, 0, 0, 0)))
#' 
#' @name mlogis
#' @export
qmlogis_first <- function(p) {
  lp <- log(p)
  lp[-1L] - lp[1L]
}

#' @rdname mlogis
#' @export
qmlogis_last <- function(p) {
  lp <- log(p)
  n <- length(p)
  lp[-n] - lp[n]
}



#' @rdname mlogis
#' @export
pmlogis_first <- function(q) {
  #if (anyNA(q)) stop('we *do* allow NA_real_ in logits')
  eq <- exp(q)
  id <- is.infinite(eq)
  ret <- if (any(id)) {
    if (all(id) && all(q < 0)) {
      c(1, q*0)
    } else if (sum(id) > 1L || q[id] < 0) {
      stop('must be single positive Inf')
    } else c(0, id)
  } else {
    y0 <- c(1, eq)
    y0/sum(y0)
  }
  if (!all(is.finite(ret))) {
    #print(q)
    stop('these multinomial logits creates NA or Inf proportions?')
  }
  return(ret)
}

#' @rdname mlogis
#' @export
pmlogis_last <- function(q) {
  #if (anyNA(q)) stop('we *do* allow NA_real_ in logits')
  eq <- exp(q)
  id <- is.infinite(eq)
  ret <- if (any(id)) {
    if (all(id) && all(q < 0)) {
      c(q*0, 1)
    } else if (sum(id) > 1L || q[id] < 0) {
      stop('must be single positive Inf')
    } else c(id, 0)
  } else {
    y0 <- c(eq, 1)
    y0/sum(y0)
  }
  if (!all(is.finite(ret))) {
    #print(q)
    stop('these multinomial logits creates NA or Inf proportions?')
  }
  return(ret)
}



