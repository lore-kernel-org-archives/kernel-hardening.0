MIME-Version: 1.0
In-Reply-To: <20170509135009.13751-3-Jason@zx2c4.com>
References: <20170509135009.13751-1-Jason@zx2c4.com> <20170509135009.13751-3-Jason@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 9 May 2017 16:09:49 +0200
Message-ID: <CAHmME9rdOuen8fLB8STVtBKj7BFG404N_E2MM6uoNrhhLN7auw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 2/5] ipsec: check return value of skb_to_sgvec always
To: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>
List-ID: <kernel-hardening.lists.openwall.com>

(The next submission of this ipsec patch will have this rebased over
the latest upstream tree.
https://git.zx2c4.com/linux-dev/log/?h=jd/safe-skb-vec )
