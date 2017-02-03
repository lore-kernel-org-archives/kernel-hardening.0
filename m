Message-Id: <20170203132558.474916683@infradead.org>
Date: Fri, 03 Feb 2017 14:25:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: [kernel-hardening] [PATCH 0/5] refcount_t and various related bits
To: elena.reshetova@intel.com, gregkh@linuxfoundation.org, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, dhowells@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi all,

Here is the refcount_t patch and some related bits that I hacked up the past
few days while playing with it in order to make it generate less aweful code
(on x86_64).

I think we can start by merging the refcount_t and kref patches, the rest can
come later if so desired. New here is the Kconfig knob to turn warnings
off -- it significantly reduces the generated code while still avoiding
the UAF.

I added David Howells because both he and hpa have suggested something like
try_cmpxchg() in the past.
