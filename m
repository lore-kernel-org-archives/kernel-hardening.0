Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Tue, 10 Jan 2017 11:57:59 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C3A6D8@IRSMSX102.ger.corp.intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-9-git-send-email-elena.reshetova@intel.com>
 <20170105022535.GA20972@linaro.org>
 <2236FBA76BA1254E88B949DDB74E612B41C380E4@IRSMSX102.ger.corp.intel.com>,<CAGXu5jKYN8WS-mkAfBNOyJ2+Zpy=0ErxS8Ow6K0hAWgkyb9Bpw@mail.gmail.com>
In-Reply-To: <CAGXu5jKYN8WS-mkAfBNOyJ2+Zpy=0ErxS8Ow6K0hAWgkyb9Bpw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFC PATCH 08/19] kernel, mm: convert from
 atomic_t to refcount_t
To: Kees Cook <keescook@chromium.org>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 5, 2017 at 1:56 AM, Reshetova, Elena=0A=
<elena.reshetova@intel.com> wrote:=0A=
>> On Thu, Dec 29, 2016 at 08:56:00AM +0200, Elena Reshetova wrote:=0A=
>> > refcount_t type and corresponding API should be=0A=
>> > used instead of atomic_t when the variable is used as=0A=
>> > a reference counter. Convert the cases found.=0A=
>> > diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c=0A=
>> > index 7dd14e8..1d59aca 100644=0A=
>> > --- a/arch/arm/kernel/smp.c=0A=
>> > +++ b/arch/arm/kernel/smp.c=0A=
>> > @@ -371,7 +371,7 @@ asmlinkage void secondary_start_kernel(void)=0A=
>> >      * reference and switch to it.=0A=
>> >      */=0A=
>> >     cpu =3D smp_processor_id();=0A=
>> > -   atomic_inc(&mm->mm_count);=0A=
>> > +   refcount_inc(&mm->mm_count);=0A=
>> >     current->active_mm =3D mm;=0A=
>> >     cpumask_set_cpu(cpu, mm_cpumask(mm));=0A=
>> >=0A=
>>=0A=
>> If this is the case, arm64 has almost the same code.=0A=
>=0A=
> Thank you! I haven't tried to build on arm64 this yet (as well as on othe=
r arches). I am pretty sure there are more cases on other arches that are m=
issed.=0A=
> That's why I was hoping that we can run this series to the automatic buil=
d infra.=0A=
>=0A=
> @Kees, how did you do it before for previous patches? Who should be conta=
cted to get a build-test on all arches?=0A=
=0A=
>Normally the 0day builder should pick it up from the mailing list, but=0A=
>if it doesn't (and it may not due to the missing prerequisite=0A=
>patches), I can create a branch on kernel.org and it will pick it up=0A=
>there.=0A=
=0A=
I don't think it picked up this one, don't know why. All prerequisites shou=
ld be in place. =0A=
Is there a way to point it to the repo? We have everything in refcount_t br=
anch here:=0A=
https://github.com/ereshetova/linux-stable/tree/refcount_t=0A=
Just note: the last lustre commit is there just for future work, I won't in=
clude it in testing since we gave up on trying to get it in shape. It is *w=
ay* too messy... =0A=
=0A=
>Are you able to build a series that includes refcount_t implementation=0A=
>(so there is a single series that contains all the prerequisites), and=0A=
>base it on v4.10-rc2? That should give 0day no problems in doing a=0A=
>merge and test (since -next mutates every day...)=0A=
=0A=
It was fully buildable at last on x86 and arm (not arm64 as was noted) and =
was based on linux-next/stable branch. =0A=
I can also rebase it to 4.10-rc2 if needed. Should be trivial. =0A=
Should we in general keep it on stable and not on linux-next? Certainly eas=
ier to test... =0A=
=0A=
Best Regards,=0A=
Elena=0A=
=0A=
-Kees=0A=
=0A=
--=0A=
Kees Cook=0A=
Nexus Security=0A=
