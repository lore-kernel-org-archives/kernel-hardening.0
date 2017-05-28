Date: Sun, 28 May 2017 01:15:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170528081541.GE22193@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-9-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1495829844-69341-9-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 08/20] randstruct: Whitelist NIU struct page
 overloading
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, "David S . Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 26, 2017 at 01:17:12PM -0700, Kees Cook wrote:
> The NIU ethernet driver intentionally stores a page struct pointer on
> top of the "mapping" field. Whitelist this case:
> 
> drivers/net/ethernet/sun/niu.c: In function ‘niu_rx_pkt_ignore’:
> drivers/net/ethernet/sun/niu.c:3402:10: note: found mismatched ssa struct pointer types: ‘struct page’ and ‘struct address_space’
> 
>     *link = (struct page *) page->mapping;
>     ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>

The driver really needs to stop doing this anyway.  It would be good
to send this out to linux-mm and netdev to come up with a better scheme.
