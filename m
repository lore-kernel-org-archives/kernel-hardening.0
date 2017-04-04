From: Kees Cook <keescook@chromium.org>
Date: Tue,  4 Apr 2017 15:12:11 -0700
Message-Id: <1491343938-75336-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2] bug: further enhance use of CHECK_DATA_CORRUPTION
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Geert Uytterhoeven <geert@linux-m68k.org>, Olof Johansson <olof@lixom.net>, Chris Wilson <chris@chris-wilson.co.uk>, George Spelvin <linux@sciencehorizons.net>, Thomas Gleixner <tglx@linutronix.de>, Josh Poimboeuf <jpoimboe@redhat.com>, David Windsor <dwindsor@gmail.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This continues in applying the CHECK_DATA_CORRUPTION tests where
appropriate, and pulling similar CONFIGs under the same check. Most
notably, this adds the checks to refcount_t so that system builders can
Oops their kernels when encountering a potential refcounter attack. (And
so now the LKDTM tests for refcount issues pass correctly.)

The series depends on the changes in -next made to lib/refcount.c,
so it might be easiest if this goes through the locking tree...

v2 is a rebase to -next and adjusts to using WARN_ONCE() instead of WARN().

-Kees

v1 was here: https://lkml.org/lkml/2017/3/6/720
