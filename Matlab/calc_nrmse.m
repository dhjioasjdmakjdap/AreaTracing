function nrmse=calc_nrmse(cir_true,cir_inv)
    mse=mean((cir_true-cir_inv).^2,'all');
    nrmse=sqrt(mse)/range(cir_true,'all');

end