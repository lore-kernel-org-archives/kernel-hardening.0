Date: Mon, 4 Dec 2017 19:21:11 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171204082111.GB21565@eros>
References: <CAJ1xhMUV8G+-e8fO2MGEWvQGpLVBsETWTpyMZ5wb9evoszZEJg@mail.gmail.com>
 <20171129101640.GC6217@eros>
 <CAPDLWs8ooetPXhuHXyCLZ2LnPRKBf0CSMoESbXMD4sGnLLNFuA@mail.gmail.com>
 <20171129204812.GE6217@eros>
 <1512133747.17323.3.camel@gmail.com>
 <20171204001106.GB27780@eros>
 <1512362481.17323.9.camel@gmail.com>
 <20171204045522.GE27780@eros>
 <CAPDLWs8biiKptmmYj45mrc+KWrV93JNQP5eLHcgTGznMj_yBow@mail.gmail.com>
 <CAPDLWs-BFQ+NF15ntxFNS4MT2kVs+k9BUYreDZeYEP1sFLQJ+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDLWs-BFQ+NF15ntxFNS4MT2kVs+k9BUYreDZeYEP1sFLQJ+w@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add support for 32-bit kernel
 addresses
To: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 04, 2017 at 10:51:53AM +0530, Kaiwan N Billimoria wrote:
> > On Mon, Dec 4, 2017 at 10:25 AM, Tobin C. Harding <me@tobin.cc> wrote:
> >>
> >> > With the 'eval', no warning, it's fine.
> >>
> >> Why not use hex()?
> >
> >> >
> >> >         foreach my $config_file (@config_files) {
> >> > +               $config_file =~ s/\R*//g;
> >>
> >> Is there some reason you don't use chomp()?
> >
> 
> Wrt your suggestions:
> 
> ---
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> index 9906dcf8b807..260b52e456f1 100755
> --- a/scripts/leaking_addresses.pl
> +++ b/scripts/leaking_addresses.pl
> @@ -266,7 +266,7 @@ sub is_false_positive
>  sub is_false_positive_ix86_32
>  {
>         my ($match) = @_;
> -       state $page_offset = eval get_page_offset(); # only gets called once
> +       state $page_offset = hex get_page_offset(); # only gets called once

I don't think this is valid ;) I meant use hex() to convert the string
to an int so it doesn't throw the warning (inside get_page_offset()).

thanks,
Tobin.
