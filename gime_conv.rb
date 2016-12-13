#! ruby -Ku

KEYMAPS = {
  :dvorak => '1234567890@^¥:,.pyfgcrl/[aoeuidhtns-];qjkxbmwvz\!"#$%&\'()0`~|*<>PYFGCRL?{AOEUIDHTNS=}+QJKXBMWVZ_'.split(''),
  :qwerty => '1234567890-^\qwertyuiop@[asdfghjkl;:]zxcvbnm,./\!"#$%&\'()~=~|QWERTYUIOP`{ASDFGHJKL+*}ZXCVBNM<>?_'.split(''),
}

def parse_keymap(input)
  found_key = KEYMAPS.each_key.find{|key| Regexp.new(key.to_s, ignore_case: true) =~ input }
  return found_key
end

def ask_keymap(msg)
  keymaps = KEYMAPS.keys.map(&:to_s).join(', ')
  print "#{msg} (#{keymaps}): "

  input = $stdin.gets()
  key = parse_keymap(input)

  if key
    puts "'#{key}'を選択しました。"
  else
    $stderr.puts "未知のキー配列です！"
    exit 1
  end

  return key
end

if ARGV.empty?
  $stderr.puts "入力ファイルを指定してください"
  exit 1
end


from_key= ask_keymap("入力ファイルのキー配列")
to_key = ask_keymap("出力ファイルのキー配列")

from = KEYMAPS[from_key.to_sym]
to = KEYMAPS[to_key.to_sym]

print "出力先: "
output = $stdin.gets().strip()

if File.exist?(output)
  print "出力ファイルはすでに存在します！ 上書きしますか？(yes/no): "
  exit 1 unless $stdin.gets() =~ /^yes/i
end

output = File.open(output, 'w+')

File.open(ARGV[0], 'r') do |f|
  f.each_line do |line|
    output.puts line.each_char.map {|c| if index = from.find_index(c) then to[index] else c end }.join()
  end
end

output.close()
puts "変換が完了しました。"
