function y = Instruction(p_window, InsPic, wRect)

% 要对读入到内存的指导语图像进行纹理化操作，输入到显存中
InsPic_Texture = Screen('MakeTexture', p_window, InsPic);

% 计算显存中的纹理化的图像的矩形
InsPic_Texture_Rect = Screen('Rect', InsPic_Texture);
InsPic_Texture_centerRect = CenterRect(InsPic_Texture_Rect, wRect);

% 将显存中的图像画到offScreen上
Screen('DrawTexture', p_window, InsPic_Texture, InsPic_Texture_Rect, InsPic_Texture_centerRect);

% 翻转Flip
Screen('Flip',p_window);

% 等待按空格键
key_Space=KbName('Space');
while 1
    [~, t, key_Code]=KbCheck;     %监听按键
    if key_Code(key_Space)
        break;
    end
end

Screen('FillRect',p_window,[0 0 0]);  % 颜色设置这里后期可能需要修改，这里是黑色，脑电实验经验为背景为192,192,192的灰色
Screen('Flip',p_window);

end