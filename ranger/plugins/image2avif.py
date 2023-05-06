import os
from ranger.core.loader import CommandLoader
from ranger.api.commands import Command

class image2avif(Command):
    '''
    将当前文件或按v选择的文件，转换为avif格式
    需要安装magick
    '''
    def execute(self):
        # 支持转换的格式
        image_suffix = ['.png', '.jpg', '.jpeg', '.webp', '.svg']
        # 转换后的格式
        to_suffix = '.avif'

        # 获取按v选择的文件
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        for filename in marked_files:
            filename = str(filename)
            if os.path.splitext(filename)[1] in image_suffix:
                new_filename = f'{os.path.splitext(filename)[0]}{to_suffix}'
                # 如果avif文件已存在，就不转换
                if os.path.exists(new_filename):
                    self.fm.notify(f'{new_filename} is exists')
                    continue
                # 转换命令 convert file.png file.avif
                self.fm.execute_command(f'echo convert {filename} {new_filename}')
                self.fm.execute_command(f'convert {filename} {new_filename}')
                # 删除原文件
                self.fm.execute_command(f'echo rm {filename}')
                self.fm.execute_command(f'rm {filename}')
        return
