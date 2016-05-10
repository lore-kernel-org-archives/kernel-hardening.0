Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 10 May 2016 10:19:11 -0700
Message-Id: <1462900755-20005-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v8 0/4] x86/KASLR: Randomize virtual address separately
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This is v8 of the last 3 patches from v7, with an additional clean-up for
the pagetable.c code. The rest of the series has landed in -tip.

The patches are:
- 1: Further clean up on pagetable.c.
- 2: Last part of Baoquan's decoupling the physical address and virtual
     address randomization of kernel text.
- 3: Remove upper bound on physical address range.
- 4: Remove lower bound on physical address range.

Thanks for putting up with my attempts at this, and for all the review!
Things really do look much cleaner. :)

-Kees

v7->v8:
- extracted identity map initialization function to be part of the
  called interface, renamed appropriately to initialize_identity_maps().
- added copyright to pagetable.c for clarity.
- shuffled initialization of mapping_info around again for good measure.
- refactored remaining patches to include call to initialize_identity_maps().
