Subject: Re: [PATCH v5 0/2] Remove false-positive VLAs when using max()
References: <1521174359-46392-1-git-send-email-keescook@chromium.org>
From: Florian Weimer <fweimer@redhat.com>
Message-ID: <ab2933a2-ca7b-eb3b-744d-bc037b1be688@redhat.com>
Date: Fri, 16 Mar 2018 12:47:58 +0100
MIME-Version: 1.0
In-Reply-To: <1521174359-46392-1-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input@vger.kernel.org, linux-btrfs@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 03/16/2018 05:25 AM, Kees Cook wrote:
> In the effort to remove all VLAs from the kernel[1], it is desirable to
> build with -Wvla. However, this warning is overly pessimistic, in that
> it is only happy with stack array sizes that are declared as constant
> expressions, and not constant values. One case of this is the evaluation
> of the max() macro which, due to its construction, ends up converting
> constant expression arguments into a constant value result. Attempts
> to adjust the behavior of max() ran afoul of version-dependent compiler
> behavior[2].

I find this commit message confusing.  VLAs have precisely defined 
semantics which differ from other arrays, and these differences can be 
observable (maybe not in the kernel, but certainly for userspace), so 
the compiler has to treat a VLA as such even if the length is a constant 
known at compile time.  (The original intent of the warning probably was 
a portability check anyway.)

If you want to catch stack frames which have unbounded size, 
-Werror=stack-usage=1000 or -Werror=vla-larger-than=1000 (with the 
constant adjusted as needed) might be the better approach.

Thanks,
Florian
