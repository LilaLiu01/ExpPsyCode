function y = Instruction(p_window,InsPic)

Screen('PutImage',p_window, InsPic);
Screen('Flip',p_window);

key_Space=KbName('Space');
while 1
    [~, key_Code, ~]=KbWait([], 3);     %��������
    if key_Code(key_Space)
        break;
    end
end

Screen('FillRect',p_window,[0 0 0]);  % ��ɫ����������ڿ�����Ҫ�޸ģ������Ǻ�ɫ���Ե�ʵ�龭��Ϊ����Ϊ192,192,192�Ļ�ɫ
Screen('Flip',p_window);

end

