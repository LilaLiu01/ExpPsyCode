function y = Instruction(p_window, InsPic, wRect)

% Ҫ�Զ��뵽�ڴ��ָ����ͼ������������������뵽�Դ���
InsPic_Texture = Screen('MakeTexture', p_window, InsPic);

% �����Դ��е�������ͼ��ľ���
InsPic_Texture_Rect = Screen('Rect', InsPic_Texture);
InsPic_Texture_centerRect = CenterRect(InsPic_Texture_Rect, wRect);

% ���Դ��е�ͼ�񻭵�offScreen��
Screen('DrawTexture', p_window, InsPic_Texture, InsPic_Texture_Rect, InsPic_Texture_centerRect);

% ��תFlip
Screen('Flip',p_window);

% �ȴ����ո��
key_Space=KbName('Space');
while 1
    [~, t, key_Code]=KbCheck;     %��������
    if key_Code(key_Space)
        break;
    end
end

Screen('FillRect',p_window,[0 0 0]);  % ��ɫ����������ڿ�����Ҫ�޸ģ������Ǻ�ɫ���Ե�ʵ�龭��Ϊ����Ϊ192,192,192�Ļ�ɫ
Screen('Flip',p_window);

end