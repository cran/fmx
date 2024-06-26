

#' @title Names of Distribution Parameters of `'mixEM'` Object
#' 
#' @description 
#' Names of distribution parameters of `'mixEM'` object, based on \CRANpkg{mixtools} 2020-02-05.
#' 
#' @param object `'mixEM'` object, currently only the returned value of 
#' \link[mixtools]{normalmixEM} and \link[mixtools]{gammamixEM} are supported
#' 
#' @returns 
#' Function [mixEM_pars] returns a \link[base]{character} \link[base]{vector}
#' 
#' @seealso 
#' \link[mixtools]{normalmixEM} \link[mixtools]{gammamixEM}
#' 
#' @export
mixEM_pars <- function(object) {
  switch(object[['ft']], normalmixEM = {
    c('mu', 'sigma')
  }, gammamixEM = {
    'gamma.pars'
  }, stop('mixEM fit type not programmed yet, its very simple though'))
}



#' @title Log-Likelihood of `'mixEM'` Object
#' 
#' @description 
#' To obtain the log-Likelihood of `'mixEM'` object, based on \CRANpkg{mixtools} 2020-02-05.
#' 
#' @param object `'mixEM'` object, currently only the returned value of 
#' \link[mixtools]{normalmixEM} and \link[mixtools]{gammamixEM} are supported
#' 
#' @param ... additional parameters, currently not in use
#' 
#' @returns 
#' Function [logLik.mixEM] returns a \link[stats]{logLik} object.
#' 
#' @importFrom stats logLik 
#' @export logLik.mixEM
#' @export
logLik.mixEM <- function(object, ...) {
  val <- object[['loglik']]
  attr(val, which = 'nobs') <- length(object[['x']])
  
  parnms <- switch(object[['ft']], normalmixEM = {
    c('mu', 'sigma')
  }, gammamixEM = {
    'gamma.pars'
  }, stop('mixEM fit type not programmed yet, its very simple though'))
  
  attr(val, which = 'df') <- (length(object[['lambda']]) - 1L) + sum(lengths(object[parnms], use.names = FALSE))
  class(val) <- 'logLik'
  return(val)
}





#' @title Sort `'mixEM'` Object by First Parameters
#' 
#' @description 
#' To sort a `'mixEM'` object by its first parameters, i.e.,
#' \eqn{\mu}'s for normal mixture, \eqn{\alpha}'s for \eqn{\gamma}-mixture, etc.
#' 
#' @param x `'mixEM'` object
#' 
#' @param decreasing \link[base]{logical} scalar. Should the sort by \eqn{mu}'s 
#' be increasing (`FALSE`, default) or decreasing (`TRUE`)?
#' 
#' @param ... additional parameters, currently not in use
#' 
#' @details 
#' \link[mixtools]{normalmixEM} does *not* order the location parameter
#' 
#' @returns 
#' 
#' Function [sort.mixEM] returns a `'mixEM'` object.
#' 
#' @seealso 
#' \link[base]{sort}
#' 
#' @export sort.mixEM
#' @export
sort.mixEM <- function(x, decreasing = FALSE, ...) {
  ret <- x
  par1st <- switch(x[['ft']], normalmixEM = {
    x[['mu']]
  }, gammamixEM = {
    x[['gamma.pars']][1L, ]
  }, stop('not supported yet'))
  comp_seq <- paste0('comp.', seq_along(par1st))
  
  o <- order(par1st, decreasing = decreasing)
  if (length(names(x[['lambda']]))) stop('they now name `lambda`?')
  ret[['lambda']] <- x[['lambda']][o]
  ret[['posterior']] <- x[['posterior']][, o] # ?mixtools::normalmixEM names `posterior`
  colnames(ret[['posterior']]) <- comp_seq
  
  switch(x[['ft']], normalmixEM = {
    ret[['mu']] <- x[['mu']][o]
    ret[['sigma']] <- x[['sigma']][o]
  }, gammamixEM = {
    ret[['gamma.pars']] <- x[['gamma.pars']][, o]
    colnames(ret[['gamma.pars']]) <- comp_seq
  }, stop('not supported yet'))
  
  return(ret)
}

