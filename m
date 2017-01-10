Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C3A6D8@IRSMSX102.ger.corp.intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-9-git-send-email-elena.reshetova@intel.com>
 <20170105022535.GA20972@linaro.org> <2236FBA76BA1254E88B949DDB74E612B41C380E4@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jKYN8WS-mkAfBNOyJ2+Zpy=0ErxS8Ow6K0hAWgkyb9Bpw@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612B41C3A6D8@IRSMSX102.ger.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 10 Jan 2017 12:34:51 -0800
Message-ID: <CAGXu5jKDYE7AHrXchNDLmvNMbvGytZDks6W1=i6+fyFX9ZGoNA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC PATCH 08/19] kernel, mm: convert from
 atomic_t to refcount_t
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 10, 2017 at 3:57 AM, Reshetova, Elena
<elena.reshetova@intel.com> wrote:
> On Thu, Jan 5, 2017 at 1:56 AM, Reshetova, Elena
> <elena.reshetova@intel.com> wrote:
>>> On Thu, Dec 29, 2016 at 08:56:00AM +0200, Elena Reshetova wrote:
>>> > refcount_t type and corresponding API should be
>>> > used instead of atomic_t when the variable is used as
>>> > a reference counter. Convert the cases found.
>>> > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
>>> > index 7dd14e8..1d59aca 100644
>>> > --- a/arch/arm/kernel/smp.c
>>> > +++ b/arch/arm/kernel/smp.c
>>> > @@ -371,7 +371,7 @@ asmlinkage void secondary_start_kernel(void)
>>> >      * reference and switch to it.
>>> >      */
>>> >     cpu = smp_processor_id();
>>> > -   atomic_inc(&mm->mm_count);
>>> > +   refcount_inc(&mm->mm_count);
>>> >     current->active_mm = mm;
>>> >     cpumask_set_cpu(cpu, mm_cpumask(mm));
>>> >
>>>
>>> If this is the case, arm64 has almost the same code.
>>
>> Thank you! I haven't tried to build on arm64 this yet (as well as on other arches). I am pretty sure there are more cases on other arches that are missed.
>> That's why I was hoping that we can run this series to the automatic build infra.
>>
>> @Kees, how did you do it before for previous patches? Who should be contacted to get a build-test on all arches?
>
>>Normally the 0day builder should pick it up from the mailing list, but
>>if it doesn't (and it may not due to the missing prerequisite
>>patches), I can create a branch on kernel.org and it will pick it up
>>there.
>
> I don't think it picked up this one, don't know why. All prerequisites should be in place.
> Is there a way to point it to the repo? We have everything in refcount_t branch here:
> https://github.com/ereshetova/linux-stable/tree/refcount_t

We could ask Fengguang to explicitly add it, but how about I just put
it in my repo on kernel.org.

> Just note: the last lustre commit is there just for future work, I won't include it in testing since we gave up on trying to get it in shape. It is *way* too messy...
>
>>Are you able to build a series that includes refcount_t implementation
>>(so there is a single series that contains all the prerequisites), and
>>base it on v4.10-rc2? That should give 0day no problems in doing a
>>merge and test (since -next mutates every day...)
>
> It was fully buildable at last on x86 and arm (not arm64 as was noted) and was based on linux-next/stable branch.
> I can also rebase it to 4.10-rc2 if needed. Should be trivial.
> Should we in general keep it on stable and not on linux-next? Certainly easier to test...

Yeah, from what I've been able to tell, with large changes, it's
easier to carry things as deltas against the -rc2 while Linus's tree
is finalizing for a release, and then once it's out, wait for -rc2
again, and rebase. That way, if things stabilize in your tree, we can
get it added to -next and things should merge "well".

Looks at the git tree you've got, it seems that authorship information
got mangled. Everything is shown as authored by you, but I'd expect a
mix of you, Hans, David, and Peter.

If you can fix that up and rebase to v4.10-rc2, I'll pull it into my
repo for 0-day to pick it up for testing.

-Kees

-- 
Kees Cook
Nexus Security
