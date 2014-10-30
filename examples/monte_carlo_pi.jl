# Calculate Pi using monte carlo method


function estimate_pi_vec()
	# Vectorized way of calculating Pi
	# This style is commonly seen in python or Matlab/Octave to avoid for loops

	samplenum=100000000
	mc_x=rand(samplenum,1)
	mc_y=rand(samplenum,1)

	R=0.5
	mc_x=mc_x-R
	mc_y=mc_y-R

	mc_l2=mc_x.^2+mc_y.^2

	r_sq=R^2

	return sum(int(mc_l2.<r_sq))*4/samplenum

end

function estimate_pi_loop(samplenum::Int64)

	R=0.5

	r_sq=R^2
	#incircle=convert(Uint64,0)
	incircle=0

	incircle=@parallel (+) for i=1:samplenum

		mc_x=rand()-R
		mc_y=rand()-R
		mc_l2=mc_x.^2+mc_y.^2

		#incircle+=convert(Uint64,mc_l2<r_sq)
		int(mc_l2<r_sq)
	end

	return incircle*4/samplenum

end


@time(println(estimate_pi_loop(convert(Int64,1e10))))

