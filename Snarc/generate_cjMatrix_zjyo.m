function cjMatrix = generate_cjMatrix_zjyo(~)

% there are two instructions -- zuo ji, you ou vs. zuo ou, you ji
% this is the zjyo version

% trialNum
repeatNum = 6;
trialNum = 8 * repeatNum;

% prepare the column names
Column_TrialID = 1;
Column_Digit = 2;
Column_digitType = 3;
Column_CorrectResponse = 4;


while 1
    mStateCountMax = 1;
    mStateCount = 1;
    % prepare
    % trialID_Arr =
    digitArr = 1:8; digitArr = digitArr';
    digitType_Arr = kron(ones(4,1),[1; 2]);
    correctResponse_Arr = digitType_Arr; % for zjyo version specially
    
    % set the tmpMatrix
    tmpMatrix_8rows = [digitArr digitType_Arr correctResponse_Arr];
    tmpMatrix_48rows = kron(ones(repeatNum,1), tmpMatrix_8rows);
    
    randArr = rand(trialNum,1);
    tmpMatrix = [tmpMatrix_48rows randArr];
    tmpMatrix_R = sortrows(tmpMatrix,4);
    tmpMatrix_3columns = tmpMatrix_R(:,1:end-1);
    
    % add the trialID_Arr
    trialID_Arr = 1:trialNum; trialID_Arr = trialID_Arr';
    cjMatrix = [trialID_Arr tmpMatrix_3columns];
    
    % LOOP: index is i
    for i = 2:length(cjMatrix)
        if cjMatrix(i,Column_CorrectResponse) == cjMatrix(i-1,Column_CorrectResponse)
            mStateCount = mStateCount + 1;
            if mStateCount > mStateCountMax
                mStateCountMax = mStateCount;
            end
        else
            mStateCount = 1;
        end
        
    end
    
    if mStateCountMax > 4
        continue;
    else
        break;
    end
end

end