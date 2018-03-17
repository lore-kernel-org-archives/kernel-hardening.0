MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180316155950.35fda7c63ec59277ba504201@linux-foundation.org>
References: <20180315225919.GA43806@beast> <20180316155950.35fda7c63ec59277ba504201@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 16 Mar 2018 23:25:43 -0700
Message-ID: <CAGXu5jLAqki8oE7AF9BEwLxKzpTOOPsT1imjdSAG_U44uGXJdQ@mail.gmail.com>
Subject: Re: [PATCH v2] rslib: Remove VLAs by setting upper bound on nroots
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 16, 2018 at 3:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 15 Mar 2018 15:59:19 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> Avoid stack VLAs[1] by always allocating the upper bound of stack space
>> needed. The existing users of rslib appear to max out at 24 roots[2],
>> so use that as the upper bound until we have a reason to change it.
>>
>> Alternative considered: make init_rs() a true caller-instance and
>> pre-allocate the workspaces. This would possibly need locking and
>> a refactoring of the returned structure.
>>
>> Using kmalloc in this path doesn't look great, especially since at
>> least one caller (pstore) is sensitive to allocations during rslib
>> usage (it expects to run it during an Oops, for example).
>
> Oh.
>
> Could we allocate the storage during init_rs(), attach it to `struct
> rs_control'?

No, because they're modified during decode, and struct rs_control is
shared between users. :(

Doing those changes is possible, but it requires a rather extensive
analysis of callers, etc.

Hence, the 24 ultimately.

-Kees

-- 
Kees Cook
Pixel Security
