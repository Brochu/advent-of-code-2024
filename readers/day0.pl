my $dim = 0;
my @grid;

while(<>) {
    my @a = split(/, /, $_);

    if ($dim == 0) {
        $dim = @a;
    }
    foreach my $elem (@a) {
        $val = $elem + 0;
        #print "'$val'\n"
        push(@grid, $val);
    }
}


my $len = @grid;
my $bin = pack("i2i*", $dim, $len, @grid);
print $bin;
