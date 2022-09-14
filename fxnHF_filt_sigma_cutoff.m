function ca_filt_data = fxnHF_filt_sigma_cutoff(ca_raw_data, sigma_cut_if_ON);

%% filtering code

    highpass = 0.01; % 30 sec highpass filter
    Ca_fs    = 20; % 20hz
    
    ca_temp_data = ca_raw_data   ;      %�@vlocked�f�[�^�̑�� ca �c�F���ԁ@���@���F�זE
   
        [b,a] = butter(1, highpass /(Ca_fs/2),'high'); %
        %[b,a] = cheby2(1, 10, highpass /(Ca_fs/2), 'high');% highpass =0.01 good  
        dataOut = filtfilt(b,a,ca_temp_data); %�[���ʑ�filtfilt�� �n�C�p�X�@�t�B���^�[��ʂ�
        
%% zscore������
% reply = input('Would you like to see an echo? (y/n): ','s');
% if strcmp(reply,'y')
%   disp(reply)
% end
% tf = strcmp(s1,s2) �́As1 �� s2 ���r���A���҂�����̏ꍇ�� 1 (true) ��Ԃ��A�����łȂ��ꍇ�� 0 (false) ��Ԃ��܂��B

% reply = input('Would you like to do Z-score normalization? (y/n): ','s');
reply ='y';
%%
if strcmp(reply,'y') % 
  disp('You chose YES. Z-score normalization done!')
  
	dataIn1 = zscore(dataOut(1:7200,:)); 	    %�@�c�Ƀt�B���^�[��������
    dataIn2 = zscore(dataOut(7201:19200,:)); 	%�@�c�Ƀt�B���^�[�������� % reshape range []
    dataIn3 = zscore(dataOut(19201:31200,:)); 	%�@�c�Ƀt�B���^�[��������
    dataIn4 = zscore(dataOut(31201:43200,:)); 	%�@�c�Ƀt�B���^�[��������
    dataIn5 = zscore(dataOut(43201:50400,:)); 	%�@�c�Ƀt�B���^�[��������
    dataIn6 = zscore(dataOut(50401:57600,:)); 	%�@�c�Ƀt�B���^�[�������� 

        dataIn = [dataIn1; dataIn2; dataIn3; dataIn4; dataIn5; dataIn6];
    ca_filt_data = (dataIn);

    negative = find(ca_filt_data<sigma_cut_if_ON); % 3SD�ȉ����J�b�g
    ca_filt_data(negative) = zeros(size(negative));
%%  
elseif  strcmp(reply,'n') % 
  disp('You chose NO. Filtering and ZERO cutoff done!')
  
  ca_filt_data = (dataOut);

    negative = find(ca_filt_data<0); % 0
    ca_filt_data(negative) = zeros(size(negative));
else
   error('Unexpected situation')
end

%%
end