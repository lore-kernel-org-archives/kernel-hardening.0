Message-ID: <1494338600.2410.6.camel@sipsolutions.net>
From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 09 May 2017 16:03:20 +0200
In-Reply-To: <20170509135009.13751-1-Jason@zx2c4.com> (sfid-20170509_155352_302082_2551EB62)
References: <20170509135009.13751-1-Jason@zx2c4.com>
	 (sfid-20170509_155352_302082_2551EB62)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v7 0/5] skb_to_sgvec hardening
To: "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-05-09 at 15:50 +0200, Jason A. Donenfeld wrote:
> The recent bug with macsec and historical one with virtio have
> indicated that letting skb_to_sgvec trounce all over an sglist
> without checking the length is probably a bad idea. And it's not
> necessary either: an sglist already explicitly marks its last
> item, and the initialization functions are diligent in doing so.
> Thus there's a clear way of avoiding future overflows.
> 
> So, this patchset, from a high level, makes skb_to_sgvec return
> a potential error code, and then adjusts all callers to check
> for the error code.

Perhaps you should add __must_check annotation to the function
prototype(s)?

johannes
