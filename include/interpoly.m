%SUBROUTINE FOR INTERPOLATION
function [gamma, beta, k_pt, kp] = interpoly( gamma_n, beta_n, k_gamma_n, k_beta_n, k_pt_n, k_p_n, k_gamma, k_beta )

nn = size( k_gamma_n );
nx = nn(1);     ny = nn(2);

for i=1:nx - 1
    i1 = 0;    j1 = 0;
    i2 = 0;    j2 = 0;
    for j=1:ny - 1
        
       %UPPER TRIANGLE
       ax = k_gamma_n( i + 1, j + 1 ) - k_gamma_n( i, j ); 
       ay = k_beta_n( i + 1, j + 1 ) - k_beta_n( i, j );
       
       bx = k_gamma_n( i + 1, j ) - k_gamma_n( i, j ); 
       by = k_beta_n( i + 1, j ) - k_beta_n( i, j );
       
       cx = k_gamma - k_gamma_n( i, j ); 
       cy = k_beta - k_beta_n( i, j );
       
       lambda1 = ( cx * by - bx * cy )/( ax * by - bx * ay );
       lambda2 = ( cy * ax - ay * cx )/( ax * by - bx * ay );

       if( ( ( lambda1 + lambda2 ) <= 1. ) && ( lambda1 >= 0. ) && ... 
             ( lambda1 <= 1. ) && ( lambda2 >= 0. ) && ( lambda2 <= 1. )  )
           i1 = i;   j1 = j;
           
           ai = k_gamma_n( i1 + 1, j1 + 1 ) * k_beta_n( i1 + 1, j1) - ... 
                k_gamma_n( i1 + 1 , j1 ) *   k_beta_n( i1 + 1, j1 + 1);
           
           bi = k_beta_n( i1 + 1, j1 + 1) - k_beta_n( i1 + 1, j1);
           
           ci = k_gamma_n( i1 + 1, j1) - k_gamma_n( i1 + 1, j1 + 1);
           
           aj = k_gamma_n( i1 + 1, j1 ) * k_beta_n( i1, j1) - ... 
                k_gamma_n( i1, j1 ) *   k_beta_n( i1 + 1, j1);
           
           bj = k_beta_n( i1 + 1, j1 ) - k_beta_n( i1 , j1);
           
           cj = k_gamma_n( i1 , j1) - k_gamma_n( i1 + 1, j1 );
           
           ak = k_gamma_n( i1 , j1 ) * k_beta_n( i1 + 1, j1 + 1) - ... 
                k_gamma_n( i1 + 1 , j1 + 1 ) *   k_beta_n( i1, j1);
           
           bk = k_beta_n( i1 , j1) - k_beta_n( i1 + 1, j1 + 1);
           
           ck = k_gamma_n( i1 + 1, j1 + 1) - k_gamma_n( i1, j1 );
           
           delta = k_gamma_n( i1 + 1, j1 + 1 ) * k_beta_n( i1 + 1, j1 ) + ... 
                   k_gamma_n( i1 , j1 ) * k_beta_n( i1 + 1, j1 + 1 ) + ... 
                   k_gamma_n( i1 + 1, j1) * k_beta_n( i1, j1 ) - ...
                   k_gamma_n( i1 + 1, j1 ) * k_beta_n( i1 + 1, j1 + 1 ) - ...
                   k_gamma_n( i1 , j1 ) * k_beta_n( i1 + 1, j1 ) - ...
                   k_gamma_n( i1 + 1, j1 + 1 ) * k_beta_n( i1, j1 );
            
            gamma = ( ai + bi * k_gamma + ci * k_beta)/delta * gamma_n( i1, j1) + ...
                    ( aj + bj * k_gamma + cj * k_beta)/delta * gamma_n( i1 + 1, j1 + 1) + ...
                    ( ak + bk * k_gamma + ck * k_beta)/delta * gamma_n( i1 + 1, j1);
                
            beta   = ( ai + bi * k_gamma + ci * k_beta)/delta * beta_n( i1, j1) + ...
                    ( aj + bj * k_gamma + cj * k_beta)/delta * beta_n( i1 + 1, j1 + 1) + ...
                    ( ak + bk * k_gamma + ck * k_beta)/delta * beta_n( i1 + 1, j1);
                
            k_pt = ( ai + bi * k_gamma + ci * k_beta)/delta * k_pt_n( i1, j1) + ...
                    ( aj + bj * k_gamma + cj * k_beta)/delta * k_pt_n( i1 + 1, j1 + 1) + ...
                    ( ak + bk * k_gamma + ck * k_beta)/delta * k_pt_n( i1 + 1, j1);
            
            kp =   ( ai + bi * k_gamma + ci * k_beta)/delta * k_p_n( i1, j1) + ...
                    ( aj + bj * k_gamma + cj * k_beta)/delta * k_p_n( i1 + 1, j1 + 1) + ...
                    ( ak + bk * k_gamma + ck * k_beta)/delta * k_p_n( i1 + 1, j1);
           break;
       end
       
       %LOWER TRIANGLE
       ax = k_gamma_n( i, j + 1 ) - k_gamma_n( i, j ); 
       ay = k_beta_n( i, j + 1 ) - k_beta_n( i, j );
       
       bx = k_gamma_n( i + 1, j + 1 ) - k_gamma_n( i, j ); 
       by = k_beta_n( i + 1, j + 1 ) - k_beta_n( i, j );
       
       cx = k_gamma - k_gamma_n( i, j ); 
       cy = k_beta - k_beta_n( i, j );
       
       lambda1 = ( cx * by - bx * cy )/( ax * by - bx * ay );
       lambda2 = ( cy * ax - ay * cx )/( ax * by - bx * ay );

       if( ( ( lambda1 + lambda2 ) <= 1. ) && ( lambda1 >= 0. ) && ... 
             ( lambda1 <= 1. ) && ( lambda2 >= 0. ) && ( lambda2 <= 1. )  )
           i2 = i;   j2 = j;
           
           ai = k_gamma_n( i2, j2 + 1 ) * k_beta_n( i2 + 1, j2 + 1 ) - ... 
                k_gamma_n( i2 + 1 , j2 + 1 ) *   k_beta_n( i2, j2 + 1);
           
           bi = k_beta_n( i2, j2 + 1) - k_beta_n( i2 + 1, j2 + 1 );
           
           ci = k_gamma_n( i2 + 1, j2 + 1 ) - k_gamma_n( i2, j2 + 1);
           
           aj = k_gamma_n( i2 + 1 , j2 + 1 ) * k_beta_n( i2, j2 ) - ... 
                k_gamma_n( i2, j2 ) *   k_beta_n( i2 + 1, j2 + 1 );
           
           bj = k_beta_n( i2 + 1, j2 + 1 ) - k_beta_n( i2 , j2 );
           
           cj = k_gamma_n( i2 , j2) - k_gamma_n( i2 + 1, j2 + 1 );
           
           ak = k_gamma_n( i2 , j2 ) * k_beta_n( i2 , j2 + 1) - ... 
                k_gamma_n( i2, j2 + 1 ) *   k_beta_n( i2, j2 );
           
           bk = k_beta_n( i2 , j2) - k_beta_n( i2, j2 + 1);
           
           ck = k_gamma_n( i2, j2 + 1) - k_gamma_n( i2, j2 );
           
           delta = k_gamma_n( i2 , j2 + 1 ) * k_beta_n( i2 + 1, j2 + 1 ) + ... 
                   k_gamma_n( i2 , j2 ) * k_beta_n( i2, j2 + 1 ) + ... 
                   k_gamma_n( i2 + 1, j2 + 1) * k_beta_n( i2, j2 ) - ...
                   k_gamma_n( i2 + 1, j2 + 1 ) * k_beta_n( i2, j2 + 1 ) - ...
                   k_gamma_n( i2 , j2 ) * k_beta_n( i2 + 1, j2 + 1 ) - ...
                   k_gamma_n( i2, j2 + 1 ) * k_beta_n( i2, j2 );
            
            gamma = ( ai + bi * k_gamma + ci * k_beta)/delta * gamma_n( i2, j2) + ...
                    ( aj + bj * k_gamma + cj * k_beta)/delta * gamma_n( i2, j2 + 1) + ...
                    ( ak + bk * k_gamma + ck * k_beta)/delta * gamma_n( i2 + 1, j2 + 1);
                
            beta   = ( ai + bi * k_gamma + ci * k_beta)/delta * beta_n( i2, j2) + ...
                    ( aj + bj * k_gamma + cj * k_beta)/delta * beta_n( i2, j2 + 1) + ...
                    ( ak + bk * k_gamma + ck * k_beta)/delta * beta_n( i2 + 1, j2 + 1);
                
            k_pt = ( ai + bi * k_gamma + ci * k_beta)/delta * k_pt_n( i2, j2) + ...
                    ( aj + bj * k_gamma + cj * k_beta)/delta * k_pt_n( i2 , j2 + 1) + ...
                    ( ak + bk * k_gamma + ck * k_beta)/delta * k_pt_n( i2 + 1, j2 + 1);
            
            kp =   ( ai + bi * k_gamma + ci * k_beta)/delta * k_p_n( i2, j2) + ...
                    ( aj + bj * k_gamma + cj * k_beta)/delta * k_p_n( i2, j2 + 1) + ...
                    ( ak + bk * k_gamma + ck * k_beta)/delta * k_p_n( i2 + 1, j2 + 1);
           break;
       end
    end 
    
    if( ( i1 > 0 ) || ( i2 > 0 ) )
        break;
    end
    
end

if( ( i1 == 0 ) && ( j1 == 0 ) && ( i2 == 0 ) && ( j2 == 0 ) )
    gamma = 360.;   beta = 360.;    k_pt = 0.;   kp = 0.;
    
end









