Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Sun, 26 Jun 2016 02:03:01 +0200
MIME-Version: 1.0
Message-ID: <576F1BB5.24129.6C9A3386@pageexec.freemail.hu>
In-reply-to: <1466817192-9586-2-git-send-email-jannh@google.com>
References: <1466817192-9586-1-git-send-email-jannh@google.com>, <1466817192-9586-2-git-send-email-jannh@google.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [RFC] kref: pin objects with dangerously high reference count
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@google.com>, jann@thejh.net
List-ID: <kernel-hardening.lists.openwall.com>

On 25 Jun 2016 at 3:13, Jann Horn wrote:

> Since 2009 or so, PaX had reference count overflow mitigation code. My main
> reasons for reinventing the wheel are:
> 
>  - PaX adds arch-specific code, both in the atomic_t operations and in
>    exception handlers. I'd like to keep the code as
>    architecture-independent as possible, especially without adding
>    complexity to assembler code, to make it more maintainable and
>    auditable.

complexity is a few simple lines of asm insns in what is already asm, hardly
a big deal ;). in exchange you'd lose on code density, performance and race
windows.

>  - The refcounting hardening from PaX does not handle the "simple reference
>    count overflow" case when just the refcounting hardening code is used as
>    a standalone patch.

i don't think that this is quite true as stated as handling this case depends
on the exact sequencing of events. there're 3 cases in practice:

1. local use

   inc_refcount -> use referenced object -> dec_refcount

   in this case inc_refcount would detect and prevent the overflow, regardless
   of how many outstanding non-local or local references there are.

2. non-local use, safe sequence

   inc_refcount -> object reference escapes to non-local memory

   same as above, this case is not exploitable because the reference wouldn't
   escape to non-local memory on overflow.

3. non-local use, unsafe sequence

   object reference escapes to non-local memory -> inc_refcount

   this case may already be a logic bug (the object could be freed between these
   two actions if there's no other synchronization mechanism protecting them) and
   a reference would escape even though the refcount itself wouldn't actually be
   incremented. further decrements could then trigger the overdecrement case and
   be exploitable as a use-after-free bug.

   the REFCOUNT feature in PaX wasn't designed to handle this case because it's
   too rare to be worth the additional code and performance impact it'd require
   to saturate the refcount in this case as well.

cheers,
 PaX Team
