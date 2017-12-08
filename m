MIME-Version: 1.0
In-Reply-To: <1512621145-4783-5-git-send-email-me@tobin.cc>
References: <1512621145-4783-1-git-send-email-me@tobin.cc> <1512621145-4783-5-git-send-email-me@tobin.cc>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Fri, 8 Dec 2017 07:25:36 +0530
Message-ID: <CAPDLWs-bdxseZee=2i5pWOG-tWSws2Ac6TzkGEZjJCbzVN4DNQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 4/5] leaking_addresses: add support for kernel config file
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Alexander Kapshuk <alexander.kapshuk@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 7, 2017 at 10:02 AM, Tobin C. Harding <me@tobin.cc> wrote:
> Features that rely on the ability to get kernel configuration options
> are ready to be implemented in script. In preparation for this we can
> add support for kernel config options as a separate patch to ease
> review.
>
> Add support for locating and parsing kernel configuration file.
>
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> Co-Developed-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
> ---
>
> get_kernel_config_option() is not super clean, any improvements most welcome.
>
> Kaiwan,
>
> This needs your Signed-off-by tag if you want me to apply it with
> the Co-Developed-tag
>
> thanks,
> Tobin.
>
Adding my signed-off tag..

Signed-off-by:  Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>

>  scripts/leaking_addresses.pl | 64 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 63 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> index cb69ccd4153a..892bfe9e01fe 100755
> --- a/scripts/leaking_addresses.pl
> +++ b/scripts/leaking_addresses.pl
> @@ -42,10 +42,10 @@ my $debug = 0;
>  my $raw = 0;
>  my $output_raw = "";   # Write raw results to file.
>  my $input_raw = "";    # Read raw results from file instead of scanning.
> -
>  my $suppress_dmesg = 0;                # Don't show dmesg in output.
>  my $squash_by_path = 0;                # Summary report grouped by absolute path.
>  my $squash_by_filename = 0;    # Summary report grouped by filename.
> +my $kernel_config_file = "";   # Kernel configuration file.
>
>  # Do not parse these files (absolute path).
>  my @skip_parse_files_abs = ('/proc/kmsg',
> @@ -100,6 +100,7 @@ Options:
>               --suppress-dmesg          Do not show dmesg results.
>               --squash-by-path          Show one result per unique path.
>               --squash-by-filename      Show one result per unique filename.
> +       --kernel-config-file=<file>     Kernel configuration file (e.g /boot/config)
>         -d, --debug                     Display debugging output.
>         -h, --help, --versionq          Display this help and exit.
>
> @@ -119,6 +120,7 @@ GetOptions(
>         'squash-by-path'        => \$squash_by_path,
>         'squash-by-filename'    => \$squash_by_filename,
>         'raw'                   => \$raw,
> +       'kernel-config-file=s'  => \$kernel_config_file,
>  ) or help(1);
>
>  help(0) if ($help);
> @@ -188,6 +190,66 @@ sub is_ppc64
>         return 0;
>  }
>
> +# gets config option value from kernel config file
> +sub get_kernel_config_option
> +{
> +       my ($option) = @_;
> +       my $value = "";
> +       my $tmp_file = "";
> +       my @config_files;
> +
> +       # Allow --kernel-config-file to override.
> +       if ($kernel_config_file ne "") {
> +               @config_files = ($kernel_config_file);
> +       } elsif (-R "/proc/config.gz") {
> +               my $tmp_file = "/tmp/tmpkconf";
> +
> +               if (system("gunzip < /proc/config.gz > $tmp_file")) {
> +                       dprint "$0: system(gunzip < /proc/config.gz) failed\n";
> +               } else {
> +                       @config_files = ($tmp_file);
> +               }
> +
> +       } else {
> +               my $file = '/boot/config-' . `uname -r`;
> +               @config_files = ($file, '/boot/config');
> +       }
> +
> +       foreach my $file (@config_files) {
> +#              chomp $config_file;
> +               $value = option_from_file($option, $file);
> +               if ($value ne "") {
> +                       last;
> +               }
> +       }
> +
> +       if ($tmp_file ne "") {
> +               system("rm -f $tmp_file");
> +       }
> +
> +       return $value;
> +}
> +
> +# Parses $file and returns kernel configuration option value.
> +sub option_from_file
> +{
> +       my ($option, $file) = @_;
> +       my $str = "";
> +       my $val = "";
> +
> +       open(my $fh, "<", $file) or return "";
> +       while (my $line = <$fh> ) {
> +               if ($line =~ /^$option/) {
> +                       ($str, $val) = split /=/, $line;
> +                       chomp($val);
> +                       last;
> +               }
> +       }
> +
> +       close $fh;
> +       return $val;
> +}
> +
>  sub is_false_positive
>  {
>         my ($match) = @_;
> --
> 2.7.4
>
