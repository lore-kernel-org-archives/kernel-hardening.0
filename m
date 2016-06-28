Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 28 Jun 2016 17:43:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <20160628094357.GA16467@gondor.apana.org.au>
References: <20160628075546.GA15690@gondor.apana.org.au>
 <1eeb00c5098d8096cdb61dc7ee1ddc61b3e80f9e.1466974736.git.luto@kernel.org>
 <cover.1466974736.git.luto@kernel.org>
 <cover.1466974736.git.luto@kernel.org>
 <699.1467100340@warthog.procyon.org.uk>
 <4339.1467104063@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4339.1467104063@warthog.procyon.org.uk>
Subject: [kernel-hardening] Re: [PATCH v4 02/29] rxrpc: Avoid using stack memory in SG lists in
 rxkad
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28, 2016 at 09:54:23AM +0100, David Howells wrote:
> 
> I'm using the per-skb state for my own purposes and might be looking at it
> elsewhere at the same time.

AFAICS this cannot happen for secure_packet/verify_packet.  In both
cases we have exclusive ownership of the skb.

But it's your code so feel free to send your own patch.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
