MIME-Version: 1.0
In-Reply-To: <1512382841.17323.11.camel@gmail.com>
References: <CAJ1xhMUV8G+-e8fO2MGEWvQGpLVBsETWTpyMZ5wb9evoszZEJg@mail.gmail.com>
 <20171129101640.GC6217@eros> <CAPDLWs8ooetPXhuHXyCLZ2LnPRKBf0CSMoESbXMD4sGnLLNFuA@mail.gmail.com>
 <20171129204812.GE6217@eros> <1512133747.17323.3.camel@gmail.com>
 <20171204001106.GB27780@eros> <1512362481.17323.9.camel@gmail.com>
 <20171204045522.GE27780@eros> <CAPDLWs8biiKptmmYj45mrc+KWrV93JNQP5eLHcgTGznMj_yBow@mail.gmail.com>
 <CAPDLWs-BFQ+NF15ntxFNS4MT2kVs+k9BUYreDZeYEP1sFLQJ+w@mail.gmail.com>
 <20171204082111.GB21565@eros> <1512382841.17323.11.camel@gmail.com>
From: Alexander Kapshuk <alexander.kapshuk@gmail.com>
Date: Mon, 4 Dec 2017 14:37:00 +0200
Message-ID: <CAJ1xhMUQXEzjrCyMd9qdu5dm00Ash8d0C7n8Y9JHRg+THW-Q_w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add support for 32-bit kernel addresses
To: Kaiwan Billimoria <kaiwan.billimoria@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 4, 2017 at 12:20 PM,  <kaiwan.billimoria@gmail.com> wrote:
> On Mon, 2017-12-04 at 19:21 +1100, Tobin C. Harding wrote:
>> On Mon, Dec 04, 2017 at 10:51:53AM +0530, Kaiwan N Billimoria wrote:
>> > > ---
>> > diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
>> > index 9906dcf8b807..260b52e456f1 100755
>> > --- a/scripts/leaking_addresses.pl
>> > +++ b/scripts/leaking_addresses.pl
>> > @@ -266,7 +266,7 @@ sub is_false_positive
>> >  sub is_false_positive_ix86_32
>> >  {
>> >         my ($match) = @_;
>> > -       state $page_offset = eval get_page_offset(); # only gets called once
>> > +       state $page_offset = hex get_page_offset(); # only gets called once
>>
>> I don't think this is valid ;) I meant use hex() to convert the string
>> to an int so it doesn't throw the warning (inside get_page_offset()).
>
> Yup, got it, thanks   :-p
> Combined patch below:
>
>
> ---
>  scripts/leaking_addresses.pl | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> index 9906dcf8b807..a595a2c66b12 100755
> --- a/scripts/leaking_addresses.pl
> +++ b/scripts/leaking_addresses.pl
> @@ -266,8 +266,7 @@ sub is_false_positive
>  sub is_false_positive_ix86_32
>  {
>         my ($match) = @_;
> -       state $page_offset = eval get_page_offset(); # only gets called once
> -
> +       state $page_offset = get_page_offset(); # only gets called once
>         if ($match =~ '\b(0x)?(f|F){8}\b') {
>                 return 1;
>         }
> @@ -283,7 +282,7 @@ sub is_false_positive_ix86_32
>  sub get_page_offset
>  {
>         my $page_offset;
> -       my $default_offset = "0xc0000000";
> +       my $default_offset = hex("0xc0000000");
>         my @config_files;
>
>         # Allow --page-offset-32bit to override.
> @@ -306,23 +305,23 @@ sub get_page_offset
>                 } else {
>                         $page_offset = parse_kernel_config_file($tmp_file);
>                         if ($page_offset ne "") {
> -                               return $page_offset;
> +                               return hex($page_offset);
>                         }
>                 }
>                 system("rm -f $tmp_file");
>         }
>
>         foreach my $config_file (@config_files) {
> -               $config_file =~ s/\R*//g;
> +               chomp $config_file;
>                 $page_offset = parse_kernel_config_file($config_file);
>                 if ($page_offset ne "") {
> -                       return $page_offset;
> +                       return hex($page_offset);
>                 }
>         }
>
>         printf STDERR "\nFailed to parse kernel config files\n";
>         printf STDERR "*** NOTE ***\n";
> -       printf STDERR "Falling back to PAGE_OFFSET = %s\n\n", $default_offset;
> +       printf STDERR "Falling back to PAGE_OFFSET = 0x%x\n\n", $default_offset;

Better use the '#' flag with the 'x' conversion specifier:
perl -e 'my $default_offset = hex("0xc0000000");printf "%#x\n", $default_offset'
0xc0000000

>
>         return $default_offset;
>  }
> --
> 2.14.3
>
> Thanks,
> Kaiwan.
>
>> thanks,
>> Tobin.
