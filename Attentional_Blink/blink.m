count = 0;
    for isi = 1:3
        for l
            ag = 1:5
            T1_Performance(isi,lag,ss) = mean(raw_data((1:ntrials + count),3));
            count = count + ntrials;
        end
    end
