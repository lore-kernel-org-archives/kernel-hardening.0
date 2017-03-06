From: Kees Cook <keescook@chromium.org>
Date: Mon,  6 Mar 2017 11:09:40 -0800
Message-Id: <1488827386-87193-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 0/6] bug: further enhance use of BUG_ON_DATA_CORRUPTION
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This continues in applying the CHECK_DATA_CORRUPTION tests where
appropriate, and pulling similar CONFIGs under the same check. Most
notably, this adds the checks to refcount_t so that system builders can
Oops their kernels when encountering a potential refcounter attack. (And
so now the LKDTM tests for refcount issues pass correctly.)

I'd love to get people's Acks in case this needs to go through the
kspp tree instead of something else, like maybe -mm if that seems better.

Thanks,

-Kees
