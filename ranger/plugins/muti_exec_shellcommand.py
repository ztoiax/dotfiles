from ranger.api.commands import Command
import os

class muti_exec_shellcommand(Command):
    '''
    通过块选文件夹，在多个目录下执行相同的命令

    useage:
    在块选的文件夹中，运行touch test命令
    muti_exec_shellcommand touch test
    '''

    def execute(self):
        cwd = self.fm.thisdir
        marked_files = cwd.get_selection()

        # 将参数变成字符串
        shellcommand = ''
        for i in range(1, 100):
            if i != '':
                shellcommand += f'{self.arg(i)} '
            else:
                break

        for dir_name in marked_files:
            # 判断是文件夹，再执行shell命令
            if os.path.isdir(str(dir_name)):
                self.fm.execute_command(f'cd {dir_name} && {shellcommand}')
                self.fm.notify(f'cd {dir_name} && {shellcommand}')
        return
