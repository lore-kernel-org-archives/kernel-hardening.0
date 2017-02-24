MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEXv5_gSLFzYnQO8FdYxNDTwpNCi1umJKmR3RC-748iamafi9w@mail.gmail.com>
References: <CAEXv5_gSLFzYnQO8FdYxNDTwpNCi1umJKmR3RC-748iamafi9w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 24 Feb 2017 10:24:36 -0800
Message-ID: <CAGXu5jLkvjf2gxddr6MX_FQTKYnMzFtfkpOuHunoDv=-aXKABw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: USERCOPY slab cache whitelisting
To: David Windsor <dwindsor@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 24, 2017 at 5:41 AM, David Windsor <dwindsor@gmail.com> wrote:
> Hi Kees,
>
> I've started looking at your proposed solution for slab cache
> whitelisting [1][2], as it applies to HARDENED_USERCOPY.  I have a few
> questions.
>
> Generally, the problem to be solved here is that there are slabs not
> marked for USERCOPY whitelisting (i.e. no SLAB_USERCOPY in the slab's
> flags) that need to have some of their memory copied to userspace.
>
> IIUC, the original PaX solution is to first copy this non-whitelisted
> slab memory to the stack, which _is_ whitelisted, before copying to
> userspace via copy_to_user().  The USERCOPY checks will then occur in
> copy_to_user().

Yeah, in PaX the exceptions will either totally bypass the usercopy
checks (when the resulting logic produces a copy_*_user() with a
builtin_const size), or, if the size is still runtime variable, it
will only only do the stack checks (since the bounce buffer is on the
stack).

> After considering the merits of this solution, you identified some
> issues inherent to the PaX solution.  Relevant to this discussion are
> (lifted from [2], listed here for convenience):
>
> - non-whitelist-workarounds are open-coded
> - non-whitelist-workarounds require a double-copy
> - non-whitelist-workarounds have explicit size maximums (e.g.
> AT_VECTOR_SIZE, sizeof(sigset_t))
> - non-whitelist-workarounds _bypass_ HARDENED_USERCOPY object address checking

IIUC, in PaX, they mostly just bypass the heap checks (since the
source has moved to the stack, see above).

> To address these issues, you suggest creating something like this:
>
> copy_to_user_n(user, kernel, dynamic-size, const-max-size)

Yeah, as a possible first RFC, this could just be:

static inline unsigned long __must_check
copy_to_user_n(void __user *to, const void *from, unsigned long n,
const unsigned long exception)
{
     if (n < exception) {
         char buf[exception];

         memcpy(buf, from, n);
         return copy_to_user(to, buf, n);
    } else {
         return copy_to_user(to, from, n);
    }
}

But likely with more sanity checks on the max size of exception to
avoid stack bloat and logic around detecting builtin_const() "n"
values which can short-circuit directly to copy_to_user(), etc.

I wouldn't think this would be generally accepted, but it addresses
the "open coded" objection (but not the double-copy inefficiency).
However, since the exceptions are _rare_ and tend to be small, perhaps
this IS the right place to start...

> My questions:
>
> 1.  Which HARDENED_USERCOPY checks are applied in copy_to_user_n()?
> All of them?

In the above example, no code changes to check_object_size() are
needed since the stack buffer skips all the heap checks.

If copy_*_user_n() is implemented by plumbing the const-max-size down
into the check_object_size() call, then I think only the SLAB_USERCOPY
check should get skipped (which leaves other heap bounds checking in
place).

> 2.  In a previous discussion, you mentioned the following:
>
>> Easy cases are to just switch to put_user() which can handle up to an
>> 8-byte exception. Things like the namei.c exception are used to detect
>> embedded dir names, so copy_to_user_n(buffer, link, len, 64) where if
>> len < 64, it skips whitelist checking, otherwise a normal
>> copy_to_user() with whitelist checks. I think the sigset solution may
>> be the best already.
>
>
> I'm not quite sure what you meant by put_user()'s 8-byte exception.
> Does this mean that if there's a size mismatch discrepancy of lte 8
> bytes, put_user() will allow the copy to proceed?  This seems
> unlikely, which is why I ask.

I think I probably confused things by bringing up put_user(). What I
meant was that when there are builtin_const sizes involved, the
inlining logic already entirely skips check_object_size(). (put_user()
and get_user() don't have any of the check_object_size() machinery for
the same reason: they always operate on builtin_const sizes of 1, 2,
4, or 8 bytes.) So what I was really trying to say was that if code
can be rewritten to use builtin_consts instead of a dynamic size, the
exception is naturally created due to check_object_size() being
entirely skipped.

> Thanks in advance for what I'm sure will be a good explanation.

Hopefully that made sense! Let me know if I can clarify further...

-Kees

>
> Thanks,
> David
>
>
> [1] Slab whitelisting: https://patchwork.kernel.org/patch/9165709/
> [2] Exceptions to slab whitelisting: https://patchwork.kernel.org/patch/9165699/

-- 
Kees Cook
Pixel Security
