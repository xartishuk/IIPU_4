require 'green_shoes'

Shoes.app title: 'Usb', width: 500, height: 290 do

  user = `logname`
  @edit_box = edit_box width: 500, height: 200
  Thread.new do
    loop do
      @edit_box.text = ""      
      @other = `lsusb -v`
      @other.split("\n\n").each do |item|
        if item.split(' ')[1].to_i == 2
          item.split("\n").each do |string|
            if string.include?('iManufacturer') and string.split(' ')[1].to_i == 1
              @edit_box.text += "#{string.split(' ')[2]} #{string.split(' ')[3]} #{string.split(' ')[4]}\n\n"
            end
          end
        end
      end
      memory = `df -h`
      media = `ls /media/#{user}`
      media.split("\n").each do |device|
        memory.split("\n").each do |data|
          if data.include?device
            @edit_box.text += device + "\n"
            @edit_box.text += "Size: #{data.split(' ')[1]}\n"
            @edit_box.text += "Used: #{data.split(' ')[2]}\n\n"
          end
        end
      end
      sleep 5
    end
  end

  para 'Enter device to Eject:', margin: 10
  @device = edit_line width: 400, margin: 10
  @eject = button 'Eject', margin: 10
  @eject.click do
    memory = `df -h`
    memory.split("\n").each do |data|
      if data.include?@device.text
        `sudo umount #{data.split(' ')[0]}`
      end
    end
  end
end
