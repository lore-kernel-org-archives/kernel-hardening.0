Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri,  6 May 2016 15:01:32 -0700
Message-Id: <1462572095-11754-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 0/3] x86/KASLR: Build identity mappings on demand
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

I'm going back to small steps. :)

This series lets the x86_64 compressed boot environment build
page table identity mappings on demand. This will be used once
we begin randomizing the physical memory position beyond the
existing identity maps.

-Kees
