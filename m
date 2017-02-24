MIME-Version: 1.0
From: David Windsor <dwindsor@gmail.com>
Date: Fri, 24 Feb 2017 08:41:59 -0500
Message-ID: <CAEXv5_gSLFzYnQO8FdYxNDTwpNCi1umJKmR3RC-748iamafi9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] USERCOPY slab cache whitelisting
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

I've started looking at your proposed solution for slab cache
whitelisting [1][2], as it applies to HARDENED_USERCOPY.  I have a few
questions.

Generally, the problem to be solved here is that there are slabs not
marked for USERCOPY whitelisting (i.e. no SLAB_USERCOPY in the slab's
flags) that need to have some of their memory copied to userspace.

IIUC, the original PaX solution is to first copy this non-whitelisted
slab memory to the stack, which _is_ whitelisted, before copying to
userspace via copy_to_user().  The USERCOPY checks will then occur in
copy_to_user().

After considering the merits of this solution, you identified some
issues inherent to the PaX solution.  Relevant to this discussion are
(lifted from [2], listed here for convenience):

- non-whitelist-workarounds are open-coded
- non-whitelist-workarounds require a double-copy
- non-whitelist-workarounds have explicit size maximums (e.g.
AT_VECTOR_SIZE, sizeof(sigset_t))
- non-whitelist-workarounds _bypass_ HARDENED_USERCOPY object address checking

To address these issues, you suggest creating something like this:

copy_to_user_n(user, kernel, dynamic-size, const-max-size)


My questions:

1.  Which HARDENED_USERCOPY checks are applied in copy_to_user_n()?
All of them?

2.  In a previous discussion, you mentioned the following:

Easy cases are to just switch to put_user() which can handle up to an
8-byte exception. Things like the namei.c exception are used to detect
embedded dir names, so copy_to_user_n(buffer, link, len, 64) where if
len < 64, it skips whitelist checking, otherwise a normal
copy_to_user() with whitelist checks. I think the sigset solution may
be the best already.


I'm not quite sure what you meant by put_user()'s 8-byte exception.
Does this mean that if there's a size mismatch discrepancy of lte 8
bytes, put_user() will allow the copy to proceed?  This seems
unlikely, which is why I ask.

Thanks in advance for what I'm sure will be a good explanation.

Thanks,
David


[1] Slab whitelisting: https://patchwork.kernel.org/patch/9165709/
[2] Exceptions to slab whitelisting: https://patchwork.kernel.org/patch/9165699/
