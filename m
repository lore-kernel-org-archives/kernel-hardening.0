From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH 0/6] Remove several VLAs in the crypto subsystem
Date: Sat,  7 Apr 2018 20:38:17 +0200
Message-Id: <1523126303-23205-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

As suggested by Laura Abbott[2], I'm resending my patch with
MAX_BLOCKSIZE and MAX_ALIGNMASK defined in an header, so they
can be used in other places.
I take this opportuinuty to deal with some other VLAs not
handled in the old patch.

[1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
[2] http://lkml.kernel.org/r/4e536889-439a-49e6-dd95-2d4286913202@redhat.com

Salvatore Mesoraca (6):
  crypto: api - laying macros for statically allocated buffers
  crypto: ctr - avoid VLA use
  crypto: api - avoid VLA use
  crypto: pcbc - avoid VLA use
  crypto: cts - avoid VLA use
  crypto: cfb - avoid VLA use

 crypto/cfb.c      | 14 ++++++++++----
 crypto/cipher.c   |  7 ++++++-
 crypto/ctr.c      | 13 +++++++++++--
 crypto/cts.c      |  8 ++++++--
 crypto/internal.h |  8 ++++++++
 crypto/pcbc.c     |  9 +++++++--
 6 files changed, 48 insertions(+), 11 deletions(-)

-- 
1.9.1
