import numpy as np

def write_vector_to_int16_tbfile(filename,x):
    _x = x.copy()
    _x = _x.astype(np.int16).tolist()
    fid = open(filename,'w+')
    for __x in _x:
        fid.write('{:d}\n'.format(__x))
    fid.close()


if __name__ == "__main__":
    
    nsmpl = int(100000)
    y = np.random.randn(nsmpl,)
    y *= (2**13)/np.std(y)
    y = np.clip(y,-1*2**15,2**15)
    write_vector_to_int16_tbfile('testbench_input.txt',y)

    
    
    
    
