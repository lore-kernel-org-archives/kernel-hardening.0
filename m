References: <1488827386-87193-1-git-send-email-keescook@chromium.org>
 <1488827386-87193-6-git-send-email-keescook@chromium.org>
 <CAGXu5jJv7ipL+Ang+AWeoUEYapjTH3sKUuSZFKWQWyTSmswwWQ@mail.gmail.com>
From: Arjan van de Ven <arjan@linux.intel.com>
Message-ID: <9cb537f0-bae3-3c64-dab0-c0484694876f@linux.intel.com>
Date: Wed, 22 Mar 2017 12:32:03 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJv7ipL+Ang+AWeoUEYapjTH3sKUuSZFKWQWyTSmswwWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 5/6] notifiers: Use CHECK_DATA_CORRUPTION() on checks
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Olof Johansson <olof@lixom.net>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 3/22/2017 12:29 PM, Kees Cook wrote:
>> When performing notifier function pointer sanity checking, allow
>> CONFIG_BUG_ON_DATA_CORRUPTION to upgrade from a WARN to a BUG.
>> Additionally enables CONFIG_DEBUG_NOTIFIERS when selecting
>> CONFIG_BUG_ON_DATA_CORRUPTION.

> Any feedback on this change? By default, this retains the existing
> WARN behavior...

if you're upgrading, is the end point really a panic() ?
e.g. do you assume people to also set panic-on-oops?
