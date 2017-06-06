From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue,  6 Jun 2017 19:48:03 +0200
Message-Id: <20170606174804.31124-13-Jason@zx2c4.com>
In-Reply-To: <20170606174804.31124-1-Jason@zx2c4.com>
References: <20170606174804.31124-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH v4 12/13] bluetooth/smp: ensure RNG is properly seeded before ECDH use
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, Eric Biggers <ebiggers3@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Marcel Holtmann <marcel@holtmann.org>, Gustavo Padovan <gustavo@padovan.org>, Johan Hedberg <johan.hedberg@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This protocol uses lots of complex cryptography that relies on securely
generated random numbers. Thus, it's important that the RNG is actually
seeded before use. Fortuantely, it appears we're always operating in
process context (there are many GFP_KERNEL allocations and other
sleeping operations), and so we can simply demand that the RNG is seeded
before we use it.

We take two strategies in this commit. The first is for the library code
that's called from other modules like hci or mgmt: here we just change
the call to get_random_bytes_wait, and return the result of the wait to
the caller, along with the other error codes of those functions like
usual. Then there's the SMP protocol handler itself, which makes many
many many calls to get_random_bytes during different phases. For this,
rather than have to change all the calls to get_random_bytes_wait and
propagate the error result, it's actually enough to just put a single
call to wait_for_random_bytes() at the beginning of the handler, to
ensure that all the subsequent invocations are safe, without having to
actually change them. Likewise, for the random address changing
function, we'd rather know early on in the function whether the RNG
initialization has been interrupted, rather than later, so we call
wait_for_random_bytes() at the top, so that later on the call to
get_random_bytes() is acceptable.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
---
 net/bluetooth/hci_request.c |  6 ++++++
 net/bluetooth/smp.c         | 18 ++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index b5faff458d8b..4078057c4fd7 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1406,6 +1406,12 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
 	struct hci_dev *hdev = req->hdev;
 	int err;
 
+	if (require_privacy) {
+		err = wait_for_random_bytes();
+		if (unlikely(err))
+			return err;
+	}
+
 	/* If privacy is enabled use a resolvable private address. If
 	 * current RPA has expired or there is something else than
 	 * the current RPA in use, then generate a new one.
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 14585edc9439..5fef1bc96f42 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -537,7 +537,9 @@ int smp_generate_rpa(struct hci_dev *hdev, const u8 irk[16], bdaddr_t *rpa)
 
 	smp = chan->data;
 
-	get_random_bytes(&rpa->b[3], 3);
+	err = get_random_bytes_wait(&rpa->b[3], 3);
+	if (unlikely(err))
+		return err;
 
 	rpa->b[5] &= 0x3f;	/* Clear two most significant bits */
 	rpa->b[5] |= 0x40;	/* Set second most significant bit */
@@ -570,7 +572,9 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
 	} else {
 		while (true) {
 			/* Seed private key with random number */
-			get_random_bytes(smp->local_sk, 32);
+			err = get_random_bytes_wait(smp->local_sk, 32);
+			if (unlikely(err))
+				return err;
 
 			/* Generate local key pair for Secure Connections */
 			if (!generate_ecdh_keys(smp->local_pk, smp->local_sk))
@@ -589,7 +593,9 @@ int smp_generate_oob(struct hci_dev *hdev, u8 hash[16], u8 rand[16])
 	SMP_DBG("OOB Public Key Y: %32phN", smp->local_pk + 32);
 	SMP_DBG("OOB Private Key:  %32phN", smp->local_sk);
 
-	get_random_bytes(smp->local_rand, 16);
+	err = get_random_bytes_wait(smp->local_rand, 16);
+	if (unlikely(err))
+		return err;
 
 	err = smp_f4(smp->tfm_cmac, smp->local_pk, smp->local_pk,
 		     smp->local_rand, 0, hash);
@@ -2831,7 +2837,11 @@ static int smp_sig_channel(struct l2cap_chan *chan, struct sk_buff *skb)
 	struct hci_conn *hcon = conn->hcon;
 	struct smp_chan *smp;
 	__u8 code, reason;
-	int err = 0;
+	int err;
+
+	err = wait_for_random_bytes();
+	if (unlikely(err))
+		return err;
 
 	if (skb->len < 1)
 		return -EILSEQ;
-- 
2.13.0
