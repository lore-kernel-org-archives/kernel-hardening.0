Date: Thu, 7 Feb 2019 16:35:55 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 3/3] leaking_addresses: Expand tilde in output file name
Message-ID: <20190207233555.GA5122@cisco>
References: <20190207225026.11723-1-tobin@kernel.org>
 <20190207225026.11723-4-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207225026.11723-4-tobin@kernel.org>
To: "Tobin C. Harding" <tobin@kernel.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 08, 2019 at 09:50:26AM +1100, Tobin C. Harding wrote:
> Currently if user passes an output file to the script via
> --output-raw we do not handle expansion of tilde.
> 
> Use perl function glob() to expand tilde in output file name.
> 
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>
> ---
>  scripts/leaking_addresses.pl | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> index ef9e5b2a1614..ce545ca3fb70 100755
> --- a/scripts/leaking_addresses.pl
> +++ b/scripts/leaking_addresses.pl
> @@ -150,7 +150,7 @@ if (!(is_supported_architecture() or $opt_32bit or $page_offset_32bit)) {
>  }
>  
>  if ($output_raw) {
> -	open my $fh, '>', $output_raw or die "$0: $output_raw: $!\n";
> +	open my $fh, '>', glob($output_raw) or die "$0: $output_raw: $!\n";

Seems like you might also have the same problem with $input_raw? I
wonder if you can just do this in GetOptions somehow, so that all
users of these further down in the script don't have to remember to do
this.

Cheers,

Tycho
