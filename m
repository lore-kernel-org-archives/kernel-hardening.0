From: Laura Abbott <labbott@redhat.com>
Date: Wed, 16 Aug 2017 15:46:48 -0700
Message-Id: <20170816224650.1089-1-labbott@redhat.com>
Subject: [kernel-hardening] [PATCHv2 0/2] Command line randomness
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is a series to add the kernel command line as a source of randomness.
The first patch is an (old) prepatory patch from me to move the stack canary
initialization later. The second patch is from Daniel Micay to actually
add the command line to the pool.

Kees suggested this go through -mm.

Thanks,
Laura

Daniel Micay (1):
  extract early boot entropy from the passed cmdline

Laura Abbott (1):
  init: Move stack canary initialization after setup_arch

 init/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.13.0
