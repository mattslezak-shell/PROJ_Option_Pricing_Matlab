# Generated with SMOP  0.41-beta
try:
    from smop.libsmop import *
except ImportError:
    raise ImportError('File compiled with `smop3`, please install `smop3` to run it.') from None
# make_mortality_table_pmf.m

    
@function
def make_mortality_table_pmf(age=None,*args,**kwargs):
    varargin = make_mortality_table_pmf.varargin
    nargin = make_mortality_table_pmf.nargin

    # Create PMF from mortality table
    
    pw=concat([0.00585,0.00037,0.00025,0.00019,0.00016,0.00013,0.00012,0.00011,0.00011,0.00011,0.0001,0.00011,0.00013,0.00016,0.00019,0.00024,0.00034,0.00043,0.00058,0.00067,0.00072,0.00082,0.00088,0.00087,0.00091,0.00094,0.00099,0.00097,0.00103,0.00106,0.00105,0.00115,0.00117,0.00121,0.0013,0.00136,0.0014,0.00148,0.0015,0.00162,0.0017,0.00191,0.00201,0.00215,0.00232,0.00251,0.00277,0.00306,0.00338,0.00373,0.00408,0.00455,0.00487,0.00537,0.00572,0.00629,0.00681,0.00737,0.00778,0.00831,0.00896,0.00973,0.01037,0.01102,0.01154,0.01245,0.01337,0.01531,0.01497,0.01706,0.01877,0.02124,0.02228,0.0243,0.02639,0.02926,0.03216,0.03504,0.03874,0.04317,0.04706,0.05294,0.05839,0.06423,0.07206,0.07838,0.08843,0.09847,0.10975,0.12206,0.13711,0.15201,0.16872,0.18425,0.20625,0.21675,0.23595,0.25591,0.27651,0.29759,0.31901,0.34057,0.3621,0.38343,0.40437,0.42477,0.44447,0.46336,0.48134,0.49832,1])
# make_mortality_table_pmf.m:4
    Nmax=length(pw) - age + 1
# make_mortality_table_pmf.m:118
    p=zeros(1,Nmax)
# make_mortality_table_pmf.m:119
    p[1]=pw(age)
# make_mortality_table_pmf.m:120
    prod=1
# make_mortality_table_pmf.m:122
    for n in arange(2,Nmax).reshape(-1):
        prod=dot(prod,(1 - pw(age + n - 2)))
# make_mortality_table_pmf.m:124
        p[n]=dot(prod,pw(age + n - 1))
# make_mortality_table_pmf.m:125
    
    return p
    
if __name__ == '__main__':
    pass
    