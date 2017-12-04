Date: Tue, 5 Dec 2017 07:59:40 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171204205940.GF21565@eros>
References: <CAPDLWs8ooetPXhuHXyCLZ2LnPRKBf0CSMoESbXMD4sGnLLNFuA@mail.gmail.com>
 <20171129204812.GE6217@eros>
 <1512133747.17323.3.camel@gmail.com>
 <20171204001106.GB27780@eros>
 <1512362481.17323.9.camel@gmail.com>
 <20171204045522.GE27780@eros>
 <CAPDLWs8biiKptmmYj45mrc+KWrV93JNQP5eLHcgTGznMj_yBow@mail.gmail.com>
 <CAPDLWs-BFQ+NF15ntxFNS4MT2kVs+k9BUYreDZeYEP1sFLQJ+w@mail.gmail.com>
 <20171204082111.GB21565@eros>
 <1512382841.17323.11.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512382841.17323.11.camel@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add support for 32-bit kernel
 addresses
To: kaiwan.billimoria@gmail.com
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Dec 04, 2017 at 03:50:41PM +0530, kaiwan.billimoria@gmail.com wrote:
> On Mon, 2017-12-04 at 19:21 +1100, Tobin C. Harding wrote:
> > On Mon, Dec 04, 2017 at 10:51:53AM +0530, Kaiwan N Billimoria wrote:
> > > > ---
> > > diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> > > index 9906dcf8b807..260b52e456f1 100755
> > > --- a/scripts/leaking_addresses.pl
> > > +++ b/scripts/leaking_addresses.pl
> > > @@ -266,7 +266,7 @@ sub is_false_positive
> > >  sub is_false_positive_ix86_32
> > >  {
> > >         my ($match) = @_;
> > > -       state $page_offset = eval get_page_offset(); # only gets called once
> > > +       state $page_offset = hex get_page_offset(); # only gets called once
> > 
> > I don't think this is valid ;) I meant use hex() to convert the string
> > to an int so it doesn't throw the warning (inside get_page_offset()).
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
>  	my ($match) = @_;
> -	state $page_offset = eval get_page_offset(); # only gets called once
> -
> +	state $page_offset = get_page_offset(); # only gets called once
>  	if ($match =~ '\b(0x)?(f|F){8}\b') {
>  		return 1;
>  	}
> @@ -283,7 +282,7 @@ sub is_false_positive_ix86_32
>  sub get_page_offset
>  {
>  	my $page_offset;
> -	my $default_offset = "0xc0000000";
> +	my $default_offset = hex("0xc0000000");

This is not what I meant. When you put together the whole patch just do
what ever you have to do to make sure none of the functions emit
warnings. My point wast that there is no need to use 'eval' to suppress
warnings.

I'm getting a bit lost with all these small patches in each email. Can
you put together a patch with all the changes to date that you are
making including the suggestions by Alexanda so we can all see where we
are up to?

FYI, it should apply cleanly on top of the 'leaks' branch of my tree.

thanks,
Tobin
