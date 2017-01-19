Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+QnAuRGKpH7tqc7LGfQ_JvTDPW8XrrCdkjizt-z0=vvw@mail.gmail.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <1484730707-29313-10-git-send-email-elena.reshetova@intel.com>
 <CAEXv5_gP0bp+NbVVEgMo=sgY5FxG1aKCCdhmF2_2vsXDzQwFOQ@mail.gmail.com> <CAGXu5j+QnAuRGKpH7tqc7LGfQ_JvTDPW8XrrCdkjizt-z0=vvw@mail.gmail.com>
From: David Windsor <dwindsor@gmail.com>
Date: Wed, 18 Jan 2017 22:29:10 -0500
Message-ID: <CAEXv5_gBx2pgej_7RQD3o+OfSY2RSkDRq_vmOLtLOq66io9BQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFCv2 PATCH 09/18] net: convert from atomic_t to refcount_t
To: Kees Cook <keescook@chromium.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 18, 2017 at 8:11 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Jan 18, 2017 at 10:39 AM, David Windsor <dwindsor@gmail.com> wrote:
>> The relevant part of the patch has been cut off, but it appears that
>> you've fixed some of the issues we identified earlier as corner cases
>> as to reference counting in net/.  In particular, inetpeer.c has its
>> own garbage collection system in place which frees shared objects when
>> their reference count became -1 (rather than 0).  The proposed
>> solution was to do a global +1 on this refcounting scheme, then
>> replace unsupported atomic_*() functions with appropriate refcount_*()
>> calls.
>>
>> When submitting this to netdev, it may make sense to separate out
>> these changes: first, do a global +1 (while still using atomic_t),
>> then convert to refcount_t.  I'm already working on this now, but I
>> didn't know if you wanted to follow this approach or not.
>
> David, if you've got the global +1 patches ready, let's start feeding
> those to netdev ASAP. We can convert them to refcount_t more easily
> after that.
>

Alright, let me get them in order and I'll submit them to netdev.  I
just wanted to make sure that an alternate approach hadn't been
decided upon.

Thanks,
David

> -Kees
>
> --
> Kees Cook
> Nexus Security
