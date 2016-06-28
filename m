Reply-To: kernel-hardening@lists.openwall.com
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1eeb00c5098d8096cdb61dc7ee1ddc61b3e80f9e.1466974736.git.luto@kernel.org>
References: <1eeb00c5098d8096cdb61dc7ee1ddc61b3e80f9e.1466974736.git.luto@kernel.org> <cover.1466974736.git.luto@kernel.org> <cover.1466974736.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32025.1467099166.1@warthog.procyon.org.uk>
Date: Tue, 28 Jun 2016 08:32:46 +0100
Message-ID: <32026.1467099166@warthog.procyon.org.uk>
Subject: [kernel-hardening] Re: [PATCH v4 02/29] rxrpc: Avoid using stack memory in SG lists in rxkad
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

Andy Lutomirski <luto@kernel.org> wrote:

> @@ -277,6 +277,7 @@ struct rxrpc_connection {
>  	struct key		*key;		/* security for this connection (client) */
>  	struct key		*server_key;	/* security for this service */
>  	struct crypto_skcipher	*cipher;	/* encryption handle */
> +	struct rxrpc_crypt	csum_iv_head;	/* leading block for csum_iv */
>  	struct rxrpc_crypt	csum_iv;	/* packet checksum base */
>  	unsigned long		events;
>  #define RXRPC_CONN_CHALLENGE	0		/* send challenge packet */

NAK.  This won't work.  csum_iv_head is per packet being processed, but you've
put it in rxrpc_connection which is shared amongst several creators/digestors
of packets.  Putting it in rxrpc_call won't work either since it's also needed
for connection level packets.

David
