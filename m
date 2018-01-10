Date: Wed, 10 Jan 2018 09:25:20 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
In-Reply-To: <1515531365-37423-3-git-send-email-keescook@chromium.org>
Message-ID: <alpine.DEB.2.20.1801100921000.7926@nuc-kabylake>
References: <1515531365-37423-1-git-send-email-keescook@chromium.org> <1515531365-37423-3-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH 02/36] usercopy: Include offset in overflow report
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, David Windsor <dave@nullcore.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@infradead.org>, "David S. Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Rik van Riel <riel@redhat.com>, Matthew Garrett <mjg59@google.com>, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 9 Jan 2018, Kees Cook wrote:

> -static void report_usercopy(unsigned long len, bool to_user, const char *type)
> +int report_usercopy(const char *name, const char *detail, bool to_user,
> +		    unsigned long offset, unsigned long len)
>  {
> -	pr_emerg("kernel memory %s attempt detected %s '%s' (%lu bytes)\n",
> +	pr_emerg("kernel memory %s attempt detected %s %s%s%s%s (offset %lu, size %lu)\n",
>  		to_user ? "exposure" : "overwrite",
> -		to_user ? "from" : "to", type ? : "unknown", len);
> +		to_user ? "from" : "to",
> +		name ? : "unknown?!",
> +		detail ? " '" : "", detail ? : "", detail ? "'" : "",
> +		offset, len);
>  	/*
>  	 * For greater effect, it would be nice to do do_group_exit(),
>  	 * but BUG() actually hooks all the lock-breaking and per-arch
>  	 * Oops code, so that is used here instead.
>  	 */
>  	BUG();

Should this be a WARN() or so? Or some configuration that changes
BUG() behavior? Otherwise

> +
> +	return -1;

This return code will never be returned.

Why a return code at all? Maybe I will see that in the following patches?
