# sed命令的常用操作
> 　sed是一种流编辑器，它是文本处理中非常中的工具，能够完美的配合正则表达式使用，功能不同凡响。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”（pattern space），接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有 改变，除非你使用重定向存储输出或者加上 -i 参数(此时处理结果不会发送值屏幕).


## 打印
 - 打印出passwd中以bash结尾的内容

		sed -n '/bash$/p' passwd
		// 其中参数-n仅显示script处理后的结果 $是匹配字符串的结束 p是sed中的打印
- 打印出passwd中以r开头的内容

		sed -n '/^r/p' passwd
		// 其中参数-n仅显示script处理后的结果 ^是匹配字符串的开始 p是sed中的打印
- 打印passwd中3-8行的内容

		sed -n '3,8p' passwd
		// 其中参数-n仅显示script处理后的结果  3,8是表示范围  p是sed中的打印
- 打印passwd中的每一行  到第五行退出

		sed  '5q' passwd
		
## 删除
- 删除passwd中以kute开头的内容

		sed -i '/^kute/d' passwd
		// 其中参数-i为直接编辑文件 ^是匹配字符串的开始 d是sed的删除命令
- 删除passwd中包含docker内容的行

		sed -i '/docker/d' passwd
		// 其中参数-i为直接编辑文件 d是sed的删除命令
- 删除passwd中第三行的首个字符d

		sed -i '3s/^d//' passwd
		// 将首个字符设置为空 以达到删除字符的目的
- 删除passwd中第三行的首个字符d

		sed -ri '3s/d(.*)/\1/' passwd
		// 截取除首个字母之外的所有字符  以达到删除字符的目的
- 删除passwd中第三行的最后一个字符n

		sed -ri '1s/(.*)n$/\1/' passwd
		// 截取除了最后一个字母之外的所有字符 以达到删除字符的目的
- 删除passwd中第三行的最后一个字符n

		sed -i '3s/n$//' passwd
		// 将最后一个字符设置为空 以达到删除字符的目的
		
## 截取
- 提取出passwd中能够的登录shell的用户 并打印出用户名和对应的家目录

		sed -nr '/bash$/s/(.*):\w:[0-9]+:[0-9]+:.*:(.*):.*/\1 \2/p' passwd
		// -r 相当于转义字符 s替换指定内容 （）截取的内容 \w 匹配字母、数字、下划线或汉字 + 重复一次或更多次 \1 自动命名的组​
		
## 替换
- 将passwd中所有的nologin全部替换成hhh

		sed -i 's/nologin/hhh/g' passwd
		// s//需要替换的内容 /g 全面替换标记
- 将passwd中1-9行的nologin全部替换成hhh

		sed -i '1,9s/nologin/hhh/g' passwd
		// 1,9s//需要替换的内容 /g 全面替换标记

## 插入
- 在passwd中第五行上插入内容

		sed -i '5i\hello' passwd
		// i\ 在当前行上面插入文本
- 在passwd中第6行下追加内容

		sed -i '6a\hello' passwd
		// a\ 在当前行下面插入文本
- 将passwd第五行修改为hello world

		sed -i '5c\hello world' passwd
		// c\ 把选定的行改为新的文本
- 在passwd每一行的行首添加字符#

		sed -i 's/^/#&/g' passwd
		// & 已匹配字符串标记
- 在passwd1-5行的行首添加字符#

		sed -i '1,5s/^/#&/' passwd
		// 1,5s 在1-5行操作
- 在passwd中每一行的最后添加#

		sed -i 's/$/&#/g' passwd
		// $匹配字符串的最后 &已匹配字符串标记
- 在passwd最后一行后插入一行

		sed -i '$a\qyeyeyowowo' passwd
		// $匹配最后  a\ 在当前行下面插入文本
- 在passwd第一行前面插入一行

		sed -i '1i\qyeyeyowowo' passwd
		// 1i\ 第一行的上面追加新的文本

## 转换
- 将字符串中的abcde转换为12345

		sed -i 'y/abcde/12345/' file
		// y表示把一个字符翻译为另外的字符（但是不用于正则表达式）

​
   