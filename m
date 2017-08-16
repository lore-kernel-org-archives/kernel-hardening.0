From: Laura Abbott <labbott@redhat.com>
Date: Wed, 16 Aug 2017 16:14:56 -0700
Message-Id: <20170816231458.2299-1-labbott@redhat.com>
Subject: [kernel-hardening] [PATCHv3 0/2] Command line randomness
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is v3 of the series to add the kernel command line as a source
of randomness. The main change from v2 is to correctly place the
command line randomness _before_ the stack canary initialization
so the canary can take advantage of that.

Daniel Micay (1):
  extract early boot entropy from the passed cmdline

Laura Abbott (1):
  init: Move stack canary initialization after setup_arch

 init/main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

-- 
2.13.0
