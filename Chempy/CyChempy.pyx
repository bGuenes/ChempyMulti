from libc.math cimport log

cpdef c_gauss(list err, list x, list mu):
	"""
	Cython function to compute gaussian
	"""
	cdef float out = 0
	for i in range(len(x)):
		out-=0.91893853320467267 + log(err[i])+(x[i]-mu[i])*(x[i]-mu[i])/(2*err[i]*err[i])
	return out
	

import numpy as np
from scipy.stats import norm

def c_likelihood_evaluation_int(double[:,:] error, double[:,:] abundance_list, double[:,:] star_abundance_list):
	'''
	This function evaluates the Gaussian for the prediction/observation comparison and returns the resulting log likelihood. The model error and the observed error are added quadratically
	
	INPUT:

	   model_error = the error coming from the models side

	   star_error_list = the error coming from the observations

	   abundance_list = the predictions

	   star_abundance_list = the observations

	OUTPUT:

	   likelihood = the summed log likelihood
	'''
	#print(error, 'error')
	#print(star_abundance_list, 'star_abundance_list')
	#print(abundance_list, 'abundance_list')
	#print(star_abundance_list.shape,abundance_list.shape,error.shape)
	
	## Too slow...
	#list_of_likelihoods = gaussian(star_abundance_list,abundance_list,error)
	
	#cdef double[:,:] list_of_likelihoods = norm.pdf(star_abundance_list,loc=abundance_list,scale=error)
	
	#print(list_of_likelihoods, 'list_of_likelihoods')
	cdef double[:,:] log_likelihood_list = -0.91893853320467267 * np.ones_like(error) - log(err) - (abundance_list-star_abundance_list)*(abundance_list-star_abundance_list)/(2.*err*err)
	#print(log_likelihood_list, 'log_likelihood_list')
	cpdef float likelihood = np.sum(log_likelihood_list)
	return likelihood
