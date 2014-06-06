matlab笔记
-------------

### java接口
 * 在matlab的command窗口输入deploytool，会在右侧弹出一个新窗口（Deployment Tool）
 * 在Deployment Tool中，点击new按钮，选择Matlab Builder for Java与Java Package。新建一个工程名字，如test
 * 确保在Deployment Tool面板中的Generate Verbose Output被勾上了
 * 将欲被java调用的m文件（如t1.m，其中包括两个参数(x,y)）从Matlab整个界面的左侧工作目录面板，拖拽到Deployment Tool中的新建的类下面的class 文件夹下
 * 点击build按钮，则会在matlab的当前目录下，生成以一个与工程同名的文件夹
 * java项目需要引用matlabroot\toolbox\javabuilder\jar\javabuilder.jar和test.jar
### ruby接口
官方并不直接支持，可以通过web service或jruby调用
