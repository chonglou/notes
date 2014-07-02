upstart 笔记
---------

 * initctl reload-configuration # 重新加载配置文件
 * initctl list # 列出任务
 * update-rc.d yourscript defaults # 设置开机启动
 * init-checkconf yourscript # 检查配置文件


#### upstart start/stop无法退出bug（start之后需要'stop servicename'start才会退出）
原因：upstart 追踪的pid与实际的不同
解决办法：reboot或自动fork进程到id为目标id为止（见下列代码）
<pre><code>
#!/usr/bin/env
 
class Workaround
  def initialize target_pid
    @target_pid = target_pid
 
    first_child
  end
 
  def first_child
    pid = fork do
      Process.setsid
 
      rio, wio = IO.pipe
 
      # Keep rio open
      until second_child rio, wio
        print "\e[A"
      end
    end
 
    Process.wait pid
  end
 
  def second_child parent_rio, parent_wio
    rio, wio = IO.pipe
 
    pid = fork do
      rio.close
      parent_wio.close
 
      puts "%20.20s" % Process.pid
 
      if Process.pid == @target_pid
        wio << 'a'
        wio.close
 
        parent_rio.read
      end
    end
    wio.close
 
    begin
      if rio.read == 'a'
        true
      else
        Process.wait pid
        false
      end
    ensure
      rio.close
    end
  end
end
 
if $0 == __FILE__
  pid = ARGV.shift
  raise "USAGE: #{$0} pid" if pid.nil?
  Workaround.new Integer pid
end
</code></pre>
