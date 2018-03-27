MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180327164532.796cdd043fece53cd9b56f8f@linux-foundation.org>
References: <20180315225919.GA43806@beast> <20180316155950.35fda7c63ec59277ba504201@linux-foundation.org>
 <CAGXu5jLAqki8oE7AF9BEwLxKzpTOOPsT1imjdSAG_U44uGXJdQ@mail.gmail.com>
 <CAGXu5j+utmcN_ot-3NJ-8C0onnu8O-DOdbAxVoatzE9UcJ-O4A@mail.gmail.com> <20180327164532.796cdd043fece53cd9b56f8f@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Mar 2018 16:55:12 -0700
Message-ID: <CAGXu5j+7cG+BQQLfxSm8xLPzF1de7_+fU-s0R5ZXjfD0jx4c8w@mail.gmail.com>
Subject: Re: [PATCH v2] rslib: Remove VLAs by setting upper bound on nroots
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 27, 2018 at 4:45 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 26 Mar 2018 16:17:57 -0700 Kees Cook <keescook@chromium.org> wrote:
>
>> On Fri, Mar 16, 2018 at 11:25 PM, Kees Cook <keescook@chromium.org> wrote:
>> > On Fri, Mar 16, 2018 at 3:59 PM, Andrew Morton
>> > <akpm@linux-foundation.org> wrote:
>> >> On Thu, 15 Mar 2018 15:59:19 -0700 Kees Cook <keescook@chromium.org> wrote:
>> >>
>> >>> Avoid stack VLAs[1] by always allocating the upper bound of stack space
>> >>> needed. The existing users of rslib appear to max out at 24 roots[2],
>> >>> so use that as the upper bound until we have a reason to change it.
>> >>>
>> >>> Alternative considered: make init_rs() a true caller-instance and
>> >>> pre-allocate the workspaces. This would possibly need locking and
>> >>> a refactoring of the returned structure.
>> >>>
>> >>> Using kmalloc in this path doesn't look great, especially since at
>> >>> least one caller (pstore) is sensitive to allocations during rslib
>> >>> usage (it expects to run it during an Oops, for example).
>> >>
>> >> Oh.
>> >>
>> >> Could we allocate the storage during init_rs(), attach it to `struct
>> >> rs_control'?
>> >
>> > No, because they're modified during decode, and struct rs_control is
>> > shared between users. :(
>> >
>> > Doing those changes is possible, but it requires a rather extensive
>> > analysis of callers, etc.
>> >
>> > Hence, the 24 ultimately.
>>
>> Can this land in -mm, or does this need further discussion?
>
> Grumble.  That share-the-rs_control-if-there's-already-a-matching-one
> thing looks like premature optimization to me :(
>
> I guess if we put this storage into the rs_control (rather than on the
> stack) then we'd have to worry about concurrent uses of it.  It looks
> like all the other fields are immutable once it's set up so there might
> be such users.  In fact, I suspect there are...

Exactly. :( This is the same conclusion tglx and I came to.

-Kees

-- 
Kees Cook
Pixel Security
