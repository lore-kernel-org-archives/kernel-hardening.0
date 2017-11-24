Date: Fri, 24 Nov 2017 16:59:35 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171124055935.GB17858@eros>
References: <1511414131.12425.14.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511414131.12425.14.camel@gmail.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] scripts: leaking_addresses: help screen updates
To: kaiwan.billimoria@gmail.com
Cc: linux-kernel@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 23, 2017 at 10:45:31AM +0530, kaiwan.billimoria@gmail.com wrote:
> The current leaking_addresses.pl script only supports showing "leaked"
> 64-bit kernel virtual addresses. This patch modifies the "help" screen in the
> following manner:
> - the '--raw', '--suppress-dmesg', '--squash-by-path' and '--squash-by-filename'
>   option switches are only meaningful when the '--input-raw=' option switch is
>   used. So, indent the 'Help' screen lines to reflect the fact.
> - an additional example demonstrating usage of the new '--page-offset'
>   parameter.
> 
> 
> Feedback welcome..
> 
> 
> Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
> ---
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> index 7ca218221486..3832abb743d7 100755
> --- a/scripts/leaking_addresses.pl
> +++ b/scripts/leaking_addresses.pl
> @@ -105,10 +105,10 @@ Options:
>  
>  	-o, --output-raw=<file>  Save results for future processing.
>  	-i, --input-raw=<file>   Read results from file instead of scanning.
> -	--raw                    Show raw results (default).
> -	--suppress-dmesg         Do not show dmesg results.
> -	--squash-by-path         Show one result per unique path.
> -	--squash-by-filename     Show one result per unique filename.
> +	      --raw                    Show raw results (default).
> +	      --suppress-dmesg         Do not show dmesg results.
> +	      --squash-by-path         Show one result per unique path.
> +	      --squash-by-filename     Show one result per unique filename.
>  	--page-offset=<hex>      PAGE_OFFSET value (for 32-bit kernels).
>  	-d, --debug              Display debugging output.
>  	-h, --help, --version    Display this help and exit.
> @@ -124,6 +124,10 @@ Examples:
>  	# View summary report.
>  	$0 --input-raw scan.out --squash-by-filename
>  
> +	# (On a 32-bit system with a 2GB:2GB VMSPLIT), pass PAGE_OFFSET value
> +	# as a parameter
> +	$0 --page-offset=0x80000000

This should be in the first patch since that is the patch that added it.

> +
>  Scans the running (32 or 64 bit) kernel for potential leaking addresses.
>  
>  EOM

Neither of these patches applies to my tree. Are you editing the diff's
by hand? I noticed the patches don't end with the version signature, like this:

----
2.7.4

thanks,
Tobin.
