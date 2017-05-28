Date: Sun, 28 May 2017 00:56:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170528075654.GC22193@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-7-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1495829844-69341-7-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 06/20] randstruct: Whitelist UNIXCB cast
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Hannes Frederic Sowa <hannes@stressinduktion.org>, "Signed-off-by : David S . Miller" <davem@davemloft.net>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 26, 2017 at 01:17:10PM -0700, Kees Cook wrote:
> This is another false positive in bad cast detection:
> 
> net/unix/af_unix.c: In function ‘unix_skb_scm_eq’:
> net/unix/af_unix.c:1621:31: note: found mismatched rhs struct pointer types: ‘struct unix_skb_parms’ and ‘char’
> 
>   const struct unix_skb_parms *u = &UNIXCB(skb);
>                                ^
> 
> UNIXCB is:
> 
> 	#define UNIXCB(skb)     (*(struct unix_skb_parms *)&((skb)->cb))
> 
> And ->cb is:
> 
> 	char                    cb[48] __aligned(8);
> 
> This is a rather crazy cast, but appears to be safe in the face of
> randomization, so whitelist it in the plugin.

We have a lot of network protocol that use the ->cb area, which makes me
wonder why this one would be so special.

It seems like everyone is just using a plain cast to a pointer without
doing the address taking trick that doesn't make sense for arrays
anyway.

Maybe we just need to fix up the af_unix code to work the same as all
other protocols?
