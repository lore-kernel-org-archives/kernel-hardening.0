Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <4EF16DE1.8010909@canonical.com>
References: <1324333066-12452-1-git-send-email-keescook@chromium.org>
	<1324333066-12452-3-git-send-email-keescook@chromium.org>
	<4EF16DE1.8010909@canonical.com>
Date: Wed, 21 Dec 2011 12:18:02 -0800
Message-ID: <CAGXu5jKDnwTnFb4ziAhPeJ_7qaqfpBEtupSaq0i3jThP9Lhc9A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
To: John Johansen <john.johansen@canonical.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Roland McGrath <roland@hack.frob.com>, James Morris <jmorris@namei.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 20, 2011 at 9:25 PM, John Johansen
<john.johansen@canonical.com> wrote:
> On 12/19/2011 02:17 PM, Kees Cook wrote:
>> This adds the Yama Linux Security Module to collect DAC security
>> improvements (specifically just ptrace restrictions for now) that have
>> existed in various forms over the years and have been carried outside th=
e
>> mainline kernel by other Linux distributions like Openwall and grsecurit=
y.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> This is looking really good. =A0I have a few notes inlined below but I di=
dn't
> find any problems.
>
> I am happy giving it an
> Acked-by: John Johansen <john.johansen@canonical.com>

Thanks for the review!

>> +/**
>> + * yama_ptracer_add - add/replace an exception for this tracer/tracee p=
air
>> + * @tracer: the task_struct of the process doing the ptrace
>> + * @tracee: the task_struct of the process to be ptraced
>> + *
>> + * Returns 0 if relationship was added, -ve on error.
>> + */
> It might be good to add a note here, or a more explicit note in the Yama
> Documentation that a tracee can only have a single tracer (+ its descenda=
nts).

Good idea; I've added a note in both places now.

>> +static int yama_ptracer_add(struct task_struct *tracer,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct task_struct *tr=
acee)
>> +{
>> + =A0 =A0 int rc =3D 0;
>> + =A0 =A0 struct ptrace_relation *added;
>> + =A0 =A0 struct ptrace_relation *entry, *relation =3D NULL;
>> +
>> + =A0 =A0 added =3D kmalloc(sizeof(*added), GFP_KERNEL);
>> + =A0 =A0 spin_lock_bh(&ptracer_relations_lock);
>> + =A0 =A0 list_for_each_entry(entry, &ptracer_relations, node)
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (entry->tracee =3D=3D tracee) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 relation =3D entry;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 if (!relation) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 relation =3D added;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!relation) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto unlock_out;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 relation->tracee =3D tracee;
>> + =A0 =A0 =A0 =A0 =A0 =A0 list_add(&relation->node, &ptracer_relations);
>> + =A0 =A0 }
>> + =A0 =A0 relation->tracer =3D tracer;
>> +
>> +unlock_out:
>> + =A0 =A0 spin_unlock_bh(&ptracer_relations_lock);
>> + =A0 =A0 if (added && added !=3D relation)
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(added);
>> +
>> + =A0 =A0 return rc;
>> +}
>> +
> I think pulling the out of the locking makes the fn a little easier to
> read.

Agreed, I've done this now. I think my original thought was "why check
'added' unless we actually need it?" But it just makes the whole thing
harder to read.

>> + =A0 =A0 spin_lock_bh(&ptracer_relations_lock);
>> + =A0 =A0 list_for_each_safe(list, safe, &ptracer_relations) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 relation =3D list_entry(list, struct ptrace_re=
lation, node);
> You could use list_for_each_entry_safe here
> =A0 =A0 =A0 =A0list_for_each_entry_safe(relation, safe, &ptracer_relation=
s, node)

Ah! Yes, thanks for catching this.

>> + * yama_task_prctl - check for Yama-specific prctl operations
>> + * @option: operation
>> + * @arg2: argument
>> + * @arg3: argument
>> + * @arg4: argument
>> + * @arg5: argument
>> + *
>> + * Return 0 on success, -ve on error. =A0-ENOSYS is returned when Yama
>> + * does not handle the given option.
>> + */
> So maybe add a note here about why the tracee is being stored via the
> group_leader, but that the tracer isn't. =A0Its not really a problem but =
I
> tripped over this at first as I was going through the code.

Yeah, dealing with when a thread might be calling these things lead to
some confusion. In the end, I have to check group_leader in a few
places, and this was a seemingly good place too. I might rework this a
bit, but in the meantime, I've added a comment explaining my
reasoning.

Thanks!

-Kees

--=20
Kees Cook
ChromeOS Security
