Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Thu, 12 Jan 2017 07:54:37 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C3C41D@IRSMSX102.ger.corp.intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-9-git-send-email-elena.reshetova@intel.com>
 <20170105022535.GA20972@linaro.org>
 <2236FBA76BA1254E88B949DDB74E612B41C380E4@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jKYN8WS-mkAfBNOyJ2+Zpy=0ErxS8Ow6K0hAWgkyb9Bpw@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C3A6D8@IRSMSX102.ger.corp.intel.com>
 <CAGXu5jKDYE7AHrXchNDLmvNMbvGytZDks6W1=i6+fyFX9ZGoNA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41C3BD08@IRSMSX102.ger.corp.intel.com>,<CAGXu5jJe0F_z5unvTg7y1myka+AP7Qn5mShEw9DS2M+c=NqpBA@mail.gmail.com>
In-Reply-To: <CAGXu5jJe0F_z5unvTg7y1myka+AP7Qn5mShEw9DS2M+c=NqpBA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFC PATCH 08/19] kernel, mm: convert from
 atomic_t to refcount_t
To: Kees Cook <keescook@chromium.org>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 11, 2017 at 1:30 AM, Reshetova, Elena=0A=
<elena.reshetova@intel.com> wrote:=0A=
> On Tue, Jan 10, 2017 at 3:57 AM, Reshetova, Elena=0A=
> <elena.reshetova@intel.com> wrote:=0A=
>> On Thu, Jan 5, 2017 at 1:56 AM, Reshetova, Elena=0A=
>> <elena.reshetova@intel.com> wrote:=0A=
>>>> On Thu, Dec 29, 2016 at 08:56:00AM +0200, Elena Reshetova wrote:=0A=
>>>> > refcount_t type and corresponding API should be=0A=
>>>> > used instead of atomic_t when the variable is used as=0A=
>>>> > a reference counter. Convert the cases found.=0A=
>>>> > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c=0A=
>>>> > index 7dd14e8..1d59aca 100644=0A=
>>>> > --- a/arch/arm/kernel/smp.c=0A=
>>>> > +++ b/arch/arm/kernel/smp.c=0A=
>>>> > @@ -371,7 +371,7 @@ asmlinkage void secondary_start_kernel(void)=0A=
>>>> >      * reference and switch to it.=0A=
>>>> >      */=0A=
>>>> >     cpu =3D smp_processor_id();=0A=
>>>> > -   atomic_inc(&mm->mm_count);=0A=
>>>> > +   refcount_inc(&mm->mm_count);=0A=
>>>> >     current->active_mm =3D mm;=0A=
>>>> >     cpumask_set_cpu(cpu, mm_cpumask(mm));=0A=
>>>> >=0A=
>>>>=0A=
>>>> If this is the case, arm64 has almost the same code.=0A=
>>>=0A=
>>> Thank you! I haven't tried to build on arm64 this yet (as well as on ot=
her arches). I am pretty sure there are more cases on other arches that are=
 missed.=0A=
>>> That's why I was hoping that we can run this series to the automatic bu=
ild infra.=0A=
>>>=0A=
>>> @Kees, how did you do it before for previous patches? Who should be con=
tacted to get a build-test on all arches?=0A=
>>=0A=
>>>Normally the 0day builder should pick it up from the mailing list, but=
=0A=
>>>if it doesn't (and it may not due to the missing prerequisite=0A=
>>>patches), I can create a branch on kernel.org and it will pick it up=0A=
>>>there.=0A=
>>=0A=
>> I don't think it picked up this one, don't know why. All prerequisites s=
hould be in place.=0A=
>> Is there a way to point it to the repo? We have everything in refcount_t=
 branch here:=0A=
>> https://github.com/ereshetova/linux-stable/tree/refcount_t=0A=
>=0A=
>>We could ask Fengguang to explicitly add it, but how about I just put=0A=
>>it in my repo on kernel.org.=0A=
>=0A=
> Sure, whatever works.=0A=
>=0A=
>> Just note: the last lustre commit is there just for future work, I won't=
 include it in testing since we gave up on trying to get it in shape. It is=
 *way* too messy...=0A=
>>=0A=
>>>Are you able to build a series that includes refcount_t implementation=
=0A=
>>>(so there is a single series that contains all the prerequisites), and=
=0A=
>>>base it on v4.10-rc2? That should give 0day no problems in doing a=0A=
>>>merge and test (since -next mutates every day...)=0A=
>>=0A=
>> It was fully buildable at last on x86 and arm (not arm64 as was noted) a=
nd was based on linux-next/stable branch.=0A=
>> I can also rebase it to 4.10-rc2 if needed. Should be trivial.=0A=
>> Should we in general keep it on stable and not on linux-next? Certainly =
easier to test...=0A=
>=0A=
>>Yeah, from what I've been able to tell, with large changes, it's=0A=
>>easier to carry things as deltas against the -rc2 while Linus's tree=0A=
>>is finalizing for a release, and then once it's out, wait for -rc2=0A=
>>again, and rebase. That way, if things stabilize in your tree, we can=0A=
>>get it added to -next and things should merge "well".=0A=
>=0A=
> Maybe stupid question: but why explicitly -rc2 vs. any other rcX?=0A=
> Now it seems the latest is rc3 and it applies nicely there. I guess I=0A=
> don't understand the release flow yet...=0A=
=0A=
>My understanding (which may be flawed) is that -rc1 takes the bulk of=0A=
>major changes, and -rc2 takes the bulk of early/large fixes. After=0A=
>-rc2, almost everything is going to be bug fixes. Also, it seems to be=0A=
>traditional to use -rc2 bases for trees that are automatically merged=0A=
>in -next.=0A=
=0A=
>Therefore, in the interests of both 0-day and -next merge ease, using=0A=
>-rc2 tends to be the best.=0A=
=0A=
Thank you for explaining this! This is clearly the knowledge I was missing.=
=0A=
I was merely seeing different rc2 as intermediate tags with no specific val=
ues. =0A=
Will be basing on rc2 from now on. =0A=
=0A=
Best Regards,=0A=
Elena.=0A=
