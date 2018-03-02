Date: Thu, 1 Mar 2018 17:13:49 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 2/2] leaking_addresses: check if file name contains
 address
Message-ID: <20180302001349.buaus74hx3xjoaqs@cisco>
References: <1519941800-27710-1-git-send-email-me@tobin.cc>
 <1519941800-27710-3-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519941800-27710-3-git-send-email-me@tobin.cc>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 02, 2018 at 09:03:20AM +1100, Tobin C. Harding wrote:
> Sometimes files may be created by using output from printk.  As the scan
> traverses the directory tree we should parse each path name and check if
> it is leaking an address.
> 
> Add check for leaking address on each path name.
> 
> Suggested-by: Tycho Andersen <tycho@tycho.ws>

Acked-by: Tycho Andersen <tycho@tycho.ws>

> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  scripts/leaking_addresses.pl | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> index 65a65aa64d26..a550c9bc34f5 100755
> --- a/scripts/leaking_addresses.pl
> +++ b/scripts/leaking_addresses.pl
> @@ -463,6 +463,16 @@ sub parse_file
>  	close $fh;
>  }
>  
> +# Checks if the actual path name is leaking a kernel address.
> +sub check_path_for_leaks
> +{
> +	my ($path) = @_;
> +
> +	if (may_leak_address($path)) {
> +		printf("Path name may contain address: $path\n");
> +	}
> +}
> +
>  # Recursively walk directory tree.
>  sub walk
>  {
> @@ -484,6 +494,8 @@ sub walk
>  
>  			next if (skip($path));
>  
> +			check_path_for_leaks($path);
> +
>  			if (-d $path) {
>  				push @dirs, $path;
>  				next;
> -- 
> 2.7.4
> 
