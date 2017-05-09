MIME-Version: 1.0
In-Reply-To: <20170509135009.13751-6-Jason@zx2c4.com>
References: <20170509135009.13751-1-Jason@zx2c4.com> <20170509135009.13751-6-Jason@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 9 May 2017 16:10:27 +0200
Message-ID: <CAHmME9oPYuT2q8_geacn=sTw0f0sgMPh2VrSEB6XEfzJS4-r6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 5/5] virtio_net: check return value of skb_to_sgvec always
To: Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 9, 2017 at 3:50 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>                 num_sg = skb_to_sgvec(skb, sq->sg + 1, 0, skb->len) + 1;

(The next submission of this will take into account this + 1 here.
https://git.zx2c4.com/linux-dev/log/?h=jd/safe-skb-vec )
