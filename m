From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Sun,  4 Jun 2017 04:16:21 +0200
Message-Id: <20170604021626.11968-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH net-next v10 0/5] Avoiding stack overflow in skb_to_sgvec
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

Changes v9->v10:
   - Spaces to tabs on one line.
   - Added some acked-by, reviewed-by lines.

Since we're down to only cleaning up things like spaces-to-tabs, I
believe we can merge this patch series. David - would you put this in
net-next, please?


The recent bug with macsec and historical one with virtio have
indicated that letting skb_to_sgvec trounce all over an sglist
without checking the length is probably a bad idea. And it's not
necessary either: an sglist already explicitly marks its last
item, and the initialization functions are diligent in doing so.
Thus there's a clear way of avoiding future overflows.

So, this patchset, from a high level, makes skb_to_sgvec return
a potential error code, and then adjusts all callers to check
for the error code. There are two situations in which skb_to_sgvec
might return such an error:

   1) When the passed in sglist is too small; and
   2) When the passed in skbuff is too deeply nested.

So, the first patch in this series handles the issues with
skb_to_sgvec directly, and the remaining ones then handle the call
sites.

Jason A. Donenfeld (5):
  skbuff: return -EMSGSIZE in skb_to_sgvec to prevent overflow
  ipsec: check return value of skb_to_sgvec always
  rxrpc: check return value of skb_to_sgvec always
  macsec: check return value of skb_to_sgvec always
  virtio_net: check return value of skb_to_sgvec always

 drivers/net/macsec.c     | 13 ++++++++--
 drivers/net/virtio_net.c |  9 +++++--
 include/linux/skbuff.h   |  8 +++---
 net/core/skbuff.c        | 65 +++++++++++++++++++++++++++++++-----------------
 net/ipv4/ah4.c           |  8 ++++--
 net/ipv4/esp4.c          | 20 +++++++++------
 net/ipv6/ah6.c           |  8 ++++--
 net/ipv6/esp6.c          | 20 +++++++++------
 net/rxrpc/rxkad.c        | 19 ++++++++++----
 9 files changed, 116 insertions(+), 54 deletions(-)

-- 
2.13.0
