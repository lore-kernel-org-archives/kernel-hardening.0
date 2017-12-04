Date: Mon, 4 Dec 2017 11:11:06 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171204001106.GB27780@eros>
References: <1511850724-2381-1-git-send-email-me@tobin.cc>
 <CAJ1xhMXjSTV92DxRz269sB=fZLEXJimr7_8PX8viamm02+xN1w@mail.gmail.com>
 <20171128211003.GY17858@eros>
 <CAJ1xhMUV8G+-e8fO2MGEWvQGpLVBsETWTpyMZ5wb9evoszZEJg@mail.gmail.com>
 <20171129101640.GC6217@eros>
 <CAPDLWs8ooetPXhuHXyCLZ2LnPRKBf0CSMoESbXMD4sGnLLNFuA@mail.gmail.com>
 <20171129204812.GE6217@eros>
 <1512133747.17323.3.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512133747.17323.3.camel@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add support for 32-bit kernel
 addresses
To: kaiwan.billimoria@gmail.com
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 01, 2017 at 06:39:07PM +0530, kaiwan.billimoria@gmail.com wrote:
> Hi,
> 
> Applies upon the previous one in this thread.
> Found and fixed some minor issues with light testing on a 32-bit x86.
> (I realize this isn't an ideal description, forgive me!).
> 
> Have also emitted a 'noisy' warning on PAGE_OFFSET fallback to 0xc00000000.
> 
> Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
> ---
>  scripts/leaking_addresses.pl | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> index fcf1ebe0f043..3a8691a642c8 100755
> --- a/scripts/leaking_addresses.pl
> +++ b/scripts/leaking_addresses.pl
> @@ -160,7 +160,6 @@ if (!$input_raw and ($squash_by_path or $squash_by_filename)) {
>  
>  if (!is_supported_architecture()) {
>  	show_detected_architecture() if $debug;
> -} else {
>  	printf "\nScript does not support your architecture, sorry.\n";
>  	printf "\nCurrently we support: \n\n";
>  	foreach(@SUPPORTED_ARCHITECTURES) {
> @@ -267,7 +266,7 @@ sub is_false_positive
>  sub is_false_positive_ix86_32
>  {
>  	my ($match) = @_;
> -	state $page_offset = get_page_offset(); # only gets called once
> +	state $page_offset = eval get_page_offset(); # only gets called once

Why do you use 'eval' here?

thanks,
Tobin.
