Date: Sat, 27 May 2017 01:44:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170527084414.GC26844@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-13-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495829844-69341-13-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 12/20] sgi-xp: Use designated initializers
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 26, 2017 at 01:17:16PM -0700, Kees Cook wrote:
> Prepare to mark sensitive kernel structures for randomization by making
> sure they're using designated initializers. These were identified during
> allyesconfig builds of x86, arm, and arm64, with most initializer fixes
> extracted from grsecurity.
> 
> To avoid casting, this implements dummy functions with full function
> prototypes.

Can we get this in ASAP?

> +static void xpc_notloaded_connect(int ch_number)
> +{ }
> +
> +static void xpc_notloaded_disconnect(int ch_number)
> +{ }

Also it might be a good idea to just check in the caller if the
methods are defined instead of having all these dummys.  A branch
is usually cheaper than an indirect call, AND it leads to less code,
AND is is less fragile.
