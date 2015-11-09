int main(){
    FILE *weight_vals_0;
    FILE *weight_vals_1;
    char weight_init_0[] = "weights_0.txt";
    char weight_init_1[] = "weights_1.txt";
    uint32_t weight_0 [128][784];
    uint32_t weight_1 [10][128];
    int i,array_idx,bram_idx;

    array_idx = 0;
    bram_idx = 0;
    weight_vals_0 = fopen(weight_init_0,"r");
    while(fscanf(weight_vals_0,"%i",&i)!=EOF ){
        weight_0[bram_idx][array_idx] = i; // initialize weight_0
        if(array_idx==783){
            bram_idx++;
            array_idx=0;
        }
        else{
            array_idx++;
        }
    }
    fclose(weight_vals_0);

    array_idx = 0;
    bram_idx = 0;
    weight_vals_1 = fopen(weight_init_1,"r");
    while(fscanf(weight_vals_1,"%i",&i)!=EOF ){
        weight_1[bram_idx][array_idx] = i; // initialize weight_1
        if(array_idx==127){
            bram_idx++;
            array_idx=0;
        }
        else{
            array_idx++;
        }
    }
    fclose(weight_vals_1);

    // check weight_0
    for(int a=0;a<128;a++){
        for(int b=0;b<784;b++){
            if(weight_0[a][b] != a) printf("wrong_0!\n");
        }
    }
    // check weight_1
    for(int a=0;a<10;a++){
        for(int b=0;b<128;b++){
            if(weight_1[a][b] != a) printf("wrong_1!\n");
        }
    }

    return 0;
}


