Message-ID: <1486766950.2192.29.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Fri, 10 Feb 2017 14:49:10 -0800
In-Reply-To: <1486766608-8791-1-git-send-email-william.c.roberts@intel.com>
References: <1486766608-8791-1-git-send-email-william.c.roberts@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] checkpatch: add warning on invalid %p extensions
To: william.c.roberts@intel.com, linux-kernel@vger.kernel.org, apw@canonical.com
Cc: keescook@chromium.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-02-10 at 14:43 -0800, william.c.roberts@intel.com wrote:
> From: William Roberts <william.c.roberts@intel.com>
> 
> The kernel supports %p extensions as documented in
> Documentation/printk-formats.txt. Warn on possibly
> improper use of non-extension characters.
> 
> One issue would be the usage of %pk when %pK should have
> been used. This has a side-effect of appearing to work
> alright, but does not respect the kptr_restrict setting
> as %pK does.
> 
> Sample output:
> WARNING: Invalid vsprintf pointer extension '%pk'
> +			printk(KERN_INFO "Could not allocate IRQ %d for PCI Applicom device. %pk\n", dev->irq, pci_get_class); // NOT OK
> 
> WARNING: Invalid vsprintf pointer extension '%pn'
> +			sprintf(buf, "%pn", x); // NOT OK
> 
> Signed-off-by: William Roberts <william.c.roberts@intel.com>
> ---
>  scripts/checkpatch.pl | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 982c52c..fa22751 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -6096,6 +6096,12 @@ sub process {
>  			      "recursive locking is bad, do not use this ever.\n" . $herecurr);
>  		}
>  
> +# check for vsprintf extension %p<foo> misuses
> +		if (get_quoted_string($line, $rawline) =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGN]).)/) {
> +			WARN("VSPRINTF_POINTER_EXTENSION",
> +			     "Invalid vsprintf pointer extension '$1'\n" . $herecurr);
> +		}
> +

nack.

You can't just use get_quoted_string.

You have to verify that the thing being scanned is
actually a format.  There are many quoted uses of
%p like %%pil and %%pstate used by inline assembly.
