From: Kees Cook <keescook@chromium.org>
Date: Fri,  3 Feb 2017 15:26:48 -0800
Message-Id: <1486164412-7338-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 0/4] refcount_t followups...
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, elena.reshetova@intel.com, gregkh@linuxfoundation.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, Hans Liljestrand <ishkamiel@gmail.com>, dhowells@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

After doing some testing on the new refcount_t series, here are some
changes to improve refcount_t for the paranoid case. ;)

Since the new LKDTM tests depend on the new API, please add them to your
series; it doesn't make sense for it to go through drivers-misc.

The first patch (Kconfig fix) could be trivially folded into the initial
refcount_t patch, too.

Thanks!

-Kees
