MIME-Version: 1.0
In-Reply-To: <30529.1494853879@warthog.procyon.org.uk>
References: <20170511194134.31183-1-Jason@zx2c4.com> <20170511194134.31183-4-Jason@zx2c4.com>
 <30529.1494853879@warthog.procyon.org.uk>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 17 May 2017 00:11:35 +0200
Message-ID: <CAHmME9p_Zgmk=1dFXzzejsMY5i+znuE0n5D5ABanKrOo=eem4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v8 3/5] rxrpc: check return value of skb_to_sgvec always
To: David Howells <dhowells@redhat.com>
Cc: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 15, 2017 at 3:11 PM, David Howells <dhowells@redhat.com> wrote:
> skb_to_sgvec() can return -EMSGSIZE in some circumstances.  You shouldn't
> return -ENOMEM here in such a case.

Noted. I'll fix this up for the next round.
