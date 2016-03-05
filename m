Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 4 Mar 2016 16:07:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20160304160751.05931d89f451626b58073489@linux-foundation.org>
In-Reply-To: <1457135448-15541-3-git-send-email-labbott@fedoraproject.org>
References: <1457135448-15541-1-git-send-email-labbott@fedoraproject.org>
	<1457135448-15541-3-git-send-email-labbott@fedoraproject.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv4 2/2] mm/page_poisoning.c: Allow for zero poisoning
To: Laura Abbott <labbott@fedoraproject.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Kees Cook <keescook@chromium.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri,  4 Mar 2016 15:50:48 -0800 Laura Abbott <labbott@fedoraproject.org> wrote:

> 
> By default, page poisoning uses a poison value (0xaa) on free. If this
> is changed to 0, the page is not only sanitized but zeroing on alloc
> with __GFP_ZERO can be skipped as well. The tradeoff is that detecting
> corruption from the poisoning is harder to detect. This feature also
> cannot be used with hibernation since pages are not guaranteed to be
> zeroed after hibernation.
> 
> Credit to Grsecurity/PaX team for inspiring this work
> 
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -1158,6 +1158,22 @@ static int __init kaslr_nohibernate_setup(char *str)
>  	return nohibernate_setup(str);
>  }
>  
> +static int __init page_poison_nohibernate_setup(char *str)
> +{
> +#ifdef CONFIG_PAGE_POISONING_ZERO
> +	/*
> +	 * The zeroing option for page poison skips the checks on alloc.
> +	 * since hibernation doesn't save free pages there's no way to
> +	 * guarantee the pages will still be zeroed.
> +	 */
> +	if (!strcmp(str, "on")) {
> +		pr_info("Disabling hibernation due to page poisoning\n");
> +		return nohibernate_setup(str);
> +	}
> +#endif
> +	return 1;
> +}

It seems a bit unfriendly to silently accept the boot option but not
actually do anything with it.  Perhaps a `#else pr_info("sorry")' is
needed.

But I bet we made the same mistake in 1000 other places.

What happens if page_poison_nohibernate_setup() simply doesn't exist
when CONFIG_PAGE_POISONING_ZERO=n?  It looks like
kernel/params.c:parse_args() says "Unknown parameter".
