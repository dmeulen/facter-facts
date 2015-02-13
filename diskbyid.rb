#
# diskbyid.rb
if Facter.value(:kernel) == 'Linux'

  disks = Hash.new { |k,v| k[v] = [] }

  exclude = %w(backdev.* dm-\d loop md mmcblk mtdblock ramzswap)
  exclude = Regexp.union(*exclude.collect { |i| Regexp.new(i) })

  Facter::Util::Resolution.exec('find /dev/disk/by-id -type l -printf "%f %l\n" 2> /dev/null').each_line do |line|
    line.strip!
    next if line.empty?
    next if line.match(exclude)
    id   = line.split(/\s+/)[0]
    disk = line.split(/\s+/)[1]
    disks[disk] = id
  end

  disks.each do |k,v|
    Facter.add("disk_by_id_#{k.tr('./','')}") do
      setcode { v }
    end
  end
end
