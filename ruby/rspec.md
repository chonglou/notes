rspec笔记
--------------


### rails整合
	gem install rspec-rails
	rails generate rspec:install

### 运行
	rspec

### 常见问题
 * 大量"loading in progress, circular require considered harmful"错误在rails4下 修改.rspec文件 去掉--warnings行
