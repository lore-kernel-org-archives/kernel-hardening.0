Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Thu, 25 Apr 2013 14:54:14 -0700
Message-Id: <1366926860-26776-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v3 0/6] kernel ASLR
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

This continues to build on the tip/kaslr patches for KASLR. This series
converts the logic to C, and moves both relocation and address selection
into the decompress_kernel path. Several areas were refactored to allow
for some code reuse (e.g. CPU flags, kernel command line).

This does not yet attempt to rework the page tables to handle an arbitrary
physical memory location on x86_64. I would love some suggestions on
how to do this. :)

-Kees
