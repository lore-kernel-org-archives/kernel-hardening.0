MIME-Version: 1.0
In-Reply-To: <20180227045458.wjrbbsxf3po656du@ast-mbp>
References: <20180227004121.3633-1-mic@digikod.net> <20180227004121.3633-6-mic@digikod.net>
 <20180227020856.teq4hobw3zwussu2@ast-mbp> <CALCETrVKRYnGJ9XNW-x7eHdMt+eGP90j7cAed-KTzp1KT_kMeQ@mail.gmail.com>
 <20180227045458.wjrbbsxf3po656du@ast-mbp>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 27 Feb 2018 05:20:55 +0000
Message-ID: <CALCETrXZ=xJEd53RhA67_VDoAKBWgUeyBi9XN7ibrE7V6nzk5Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 05/11] seccomp,landlock: Enforce Landlock
 programs per process hierarchy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>, Will Drewry <wad@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 27, 2018 at 4:54 AM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Tue, Feb 27, 2018 at 04:40:34AM +0000, Andy Lutomirski wrote:
>> On Tue, Feb 27, 2018 at 2:08 AM, Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>> > On Tue, Feb 27, 2018 at 01:41:15AM +0100, Micka=C3=ABl Sala=C3=BCn wro=
te:
>> >> The seccomp(2) syscall can be used by a task to apply a Landlock prog=
ram
>> >> to itself. As a seccomp filter, a Landlock program is enforced for th=
e
>> >> current task and all its future children. A program is immutable and =
a
>> >> task can only add new restricting programs to itself, forming a list =
of
>> >> programss.
>> >>
>> >> A Landlock program is tied to a Landlock hook. If the action on a ker=
nel
>> >> object is allowed by the other Linux security mechanisms (e.g. DAC,
>> >> capabilities, other LSM), then a Landlock hook related to this kind o=
f
>> >> object is triggered. The list of programs for this hook is then
>> >> evaluated. Each program return a 32-bit value which can deny the acti=
on
>> >> on a kernel object with a non-zero value. If every programs of the li=
st
>> >> return zero, then the action on the object is allowed.
>> >>
>> >> Multiple Landlock programs can be chained to share a 64-bits value fo=
r a
>> >> call chain (e.g. evaluating multiple elements of a file path).  This
>> >> chaining is restricted when a process construct this chain by loading=
 a
>> >> program, but additional checks are performed when it requests to appl=
y
>> >> this chain of programs to itself.  The restrictions ensure that it is
>> >> not possible to call multiple programs in a way that would imply to
>> >> handle multiple shared values (i.e. cookies) for one chain.  For now,
>> >> only a fs_pick program can be chained to the same type of program,
>> >> because it may make sense if they have different triggers (cf. next
>> >> commits).  This restrictions still allows to reuse Landlock programs =
in
>> >> a safe way (e.g. use the same loaded fs_walk program with multiple
>> >> chains of fs_pick programs).
>> >>
>> >> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>> >
>> > ...
>> >
>> >> +struct landlock_prog_set *landlock_prepend_prog(
>> >> +             struct landlock_prog_set *current_prog_set,
>> >> +             struct bpf_prog *prog)
>> >> +{
>> >> +     struct landlock_prog_set *new_prog_set =3D current_prog_set;
>> >> +     unsigned long pages;
>> >> +     int err;
>> >> +     size_t i;
>> >> +     struct landlock_prog_set tmp_prog_set =3D {};
>> >> +
>> >> +     if (prog->type !=3D BPF_PROG_TYPE_LANDLOCK_HOOK)
>> >> +             return ERR_PTR(-EINVAL);
>> >> +
>> >> +     /* validate memory size allocation */
>> >> +     pages =3D prog->pages;
>> >> +     if (current_prog_set) {
>> >> +             size_t i;
>> >> +
>> >> +             for (i =3D 0; i < ARRAY_SIZE(current_prog_set->programs=
); i++) {
>> >> +                     struct landlock_prog_list *walker_p;
>> >> +
>> >> +                     for (walker_p =3D current_prog_set->programs[i]=
;
>> >> +                                     walker_p; walker_p =3D walker_p=
->prev)
>> >> +                             pages +=3D walker_p->prog->pages;
>> >> +             }
>> >> +             /* count a struct landlock_prog_set if we need to alloc=
ate one */
>> >> +             if (refcount_read(&current_prog_set->usage) !=3D 1)
>> >> +                     pages +=3D round_up(sizeof(*current_prog_set), =
PAGE_SIZE)
>> >> +                             / PAGE_SIZE;
>> >> +     }
>> >> +     if (pages > LANDLOCK_PROGRAMS_MAX_PAGES)
>> >> +             return ERR_PTR(-E2BIG);
>> >> +
>> >> +     /* ensure early that we can allocate enough memory for the new
>> >> +      * prog_lists */
>> >> +     err =3D store_landlock_prog(&tmp_prog_set, current_prog_set, pr=
og);
>> >> +     if (err)
>> >> +             return ERR_PTR(err);
>> >> +
>> >> +     /*
>> >> +      * Each task_struct points to an array of prog list pointers.  =
These
>> >> +      * tables are duplicated when additions are made (which means e=
ach
>> >> +      * table needs to be refcounted for the processes using it). Wh=
en a new
>> >> +      * table is created, all the refcounters on the prog_list are b=
umped (to
>> >> +      * track each table that references the prog). When a new prog =
is
>> >> +      * added, it's just prepended to the list for the new table to =
point
>> >> +      * at.
>> >> +      *
>> >> +      * Manage all the possible errors before this step to not usele=
ssly
>> >> +      * duplicate current_prog_set and avoid a rollback.
>> >> +      */
>> >> +     if (!new_prog_set) {
>> >> +             /*
>> >> +              * If there is no Landlock program set used by the curr=
ent task,
>> >> +              * then create a new one.
>> >> +              */
>> >> +             new_prog_set =3D new_landlock_prog_set();
>> >> +             if (IS_ERR(new_prog_set))
>> >> +                     goto put_tmp_lists;
>> >> +     } else if (refcount_read(&current_prog_set->usage) > 1) {
>> >> +             /*
>> >> +              * If the current task is not the sole user of its Land=
lock
>> >> +              * program set, then duplicate them.
>> >> +              */
>> >> +             new_prog_set =3D new_landlock_prog_set();
>> >> +             if (IS_ERR(new_prog_set))
>> >> +                     goto put_tmp_lists;
>> >> +             for (i =3D 0; i < ARRAY_SIZE(new_prog_set->programs); i=
++) {
>> >> +                     new_prog_set->programs[i] =3D
>> >> +                             READ_ONCE(current_prog_set->programs[i]=
);
>> >> +                     if (new_prog_set->programs[i])
>> >> +                             refcount_inc(&new_prog_set->programs[i]=
->usage);
>> >> +             }
>> >> +
>> >> +             /*
>> >> +              * Landlock program set from the current task will not =
be freed
>> >> +              * here because the usage is strictly greater than 1. I=
t is
>> >> +              * only prevented to be freed by another task thanks to=
 the
>> >> +              * caller of landlock_prepend_prog() which should be lo=
cked if
>> >> +              * needed.
>> >> +              */
>> >> +             landlock_put_prog_set(current_prog_set);
>> >> +     }
>> >> +
>> >> +     /* prepend tmp_prog_set to new_prog_set */
>> >> +     for (i =3D 0; i < ARRAY_SIZE(tmp_prog_set.programs); i++) {
>> >> +             /* get the last new list */
>> >> +             struct landlock_prog_list *last_list =3D
>> >> +                     tmp_prog_set.programs[i];
>> >> +
>> >> +             if (last_list) {
>> >> +                     while (last_list->prev)
>> >> +                             last_list =3D last_list->prev;
>> >> +                     /* no need to increment usage (pointer replacem=
ent) */
>> >> +                     last_list->prev =3D new_prog_set->programs[i];
>> >> +                     new_prog_set->programs[i] =3D tmp_prog_set.prog=
rams[i];
>> >> +             }
>> >> +     }
>> >> +     new_prog_set->chain_last =3D tmp_prog_set.chain_last;
>> >> +     return new_prog_set;
>> >> +
>> >> +put_tmp_lists:
>> >> +     for (i =3D 0; i < ARRAY_SIZE(tmp_prog_set.programs); i++)
>> >> +             put_landlock_prog_list(tmp_prog_set.programs[i]);
>> >> +     return new_prog_set;
>> >> +}
>> >
>> > Nack on the chaining concept.
>> > Please do not reinvent the wheel.
>> > There is an existing mechanism for attaching/detaching/quering multipl=
e
>> > programs attached to cgroup and tracing hooks that are also
>> > efficiently executed via BPF_PROG_RUN_ARRAY.
>> > Please use that instead.
>> >
>>
>> I don't see how that would help.  Suppose you add a filter, then
>> fork(), and then the child adds another filter.  Do you want to
>> duplicate the entire array?  You certainly can't *modify* the array
>> because you'll affect processes that shouldn't be affected.
>>
>> In contrast, doing this through seccomp like the earlier patches
>> seemed just fine to me, and seccomp already had the right logic.
>
> it doesn't look to me that existing seccomp side of managing fork
> situation can be reused. Here there is an attempt to add 'chaining'
> concept which sort of an extension of existing seccomp style,
> but somehow heavily done on bpf side and contradicts cgroup/tracing.
>

I don't see why the seccomp way can't be used.  I agree with you that
the seccomp *style* shouldn't be used in bpf code like this, but I
think that Landlock programs can and should just live in the existing
seccomp chain.  If the existing seccomp code needs some modification
to make this work, then so be it.

In other words, the kernel already has two kinds of chaining:
seccomp's and bpf's.  bpf's doesn't work right for this type of usage
across fork(), whereas seccomp's already handles that case correctly.
(In contrast, seccomp's is totally wrong for cgroup-attached filters.)
 So IMO Landlock should use the seccomp core code and call into bpf
for the actual filtering.

For what it's worth, I haven't figured out that Micka=C3=ABl means about
chaining restrictions involving cookies.  This seems like something
wrong and the design is too complicated.
